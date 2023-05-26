import os
import Foundation
import LocalAuthentication

// ===============
//   Extensions
// ===============
extension String {
  func dropPrefix(_ prefix: String) -> String {
    guard self.hasPrefix(prefix) else { return self }
    return String(self.dropFirst(prefix.count))
  }

  func separate(sep: String = " ") -> (String, String) {
    let parts = self.components(separatedBy: sep)
    return (head: parts.first ?? "", tail: parts.dropFirst().joined(separator: sep))
  }

  func nilIfBlank() -> String? {
    return self.isEmpty ? nil : self
  }
}


// ===============
//    Domain
// ===============
struct KeychainItem {
  var key: String? = nil
  var name: String? = nil
  var email: String? = nil
  var ssh: String? = nil
  let service = "GnuPG"

  func describe() -> String {
    if let n = name, let m = email {
      return "access the PIN for \(n) <\(m)>" + (ssh.map { " (ID \($0))" } ?? "")
    }

    if let sh = ssh {
      return "access the PIN for SSH Key \(sh)"
    }

    return "log in to your account"
  }

  func label() -> String {
    if let n = name, let m = email {
      return "\(n) <\(m)>"
    }

    if let sh = ssh {
      return "PGP-SSH: \(sh)"
    }

    return service
  }
}

enum KeychainError: Error {
  // Attempted read for an item that does not exist.
  case itemNotFound

  // Attempted save to override an existing item.
  // Use update instead of save to update existing items
  case duplicateItem

  // A read of an item in any format other than Data
  case invalidItemFormat

  // Any operation result status than errSecSuccess
  case unexpectedStatus(OSStatus)
}

struct KeychainStore {
  static func exists(service: String, account: String) throws -> Bool {
    let query: [String: Any] = [
      // kSecAttrService,  kSecAttrAccount, and kSecClass
      // uniquely identify the item to read in Keychain
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecClass as String: kSecClassGenericPassword,

      // kSecMatchLimitOne indicates keychain should read
      // only the most recent item matching this query
      kSecMatchLimit as String: kSecMatchLimitOne,

      // kSecReturnData is set to kCFBooleanTrue in order
      // to retrieve the data for the item
      kSecReturnData as String: kCFBooleanTrue ?? true
    ]

    // SecItemCopyMatching will attempt to copy the item
    // identified by query to the reference itemCopy
    var itemCopy: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &itemCopy)

    // errSecItemNotFound is a special status indicating the
    // read item does not exist. Throw itemNotFound so the
    // client can determine whether or not to handle
    // this case
    return status != errSecItemNotFound
  }

  static func save(label: String, service: String, account: String, password: Data) throws {
    let query: [String: Any] = [
      // kSecAttrService,  kSecAttrAccount, and kSecClass
      // uniquely identify the item to save in Keychain
      kSecAttrLabel as String: label,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecClass as String: kSecClassGenericPassword,

      // kSecAttrAccessible allows the item to be accessed
      // when the device is unlocked
      kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,

      // kSecAttrSynchronizable disallows synchronization
      kSecAttrSynchronizable as String: kCFBooleanFalse ?? false,

      // kSecValueData is the item value to save
      kSecValueData as String: password
    ]

    // SecItemAdd attempts to add the item identified by
    // the query to keychain
    let status = SecItemAdd(query as CFDictionary, nil)

    // errSecDuplicateItem is a special case where the
    // item identified by the query already exists. Throw
    // duplicateItem so the client can determine whether
    // or not to handle this as an error
    if status == errSecDuplicateItem {
      throw KeychainError.duplicateItem
    }

    // Any status other than errSecSuccess indicates the
    // save operation failed.
    guard status == errSecSuccess else {
      throw KeychainError.unexpectedStatus(status)
    }
  }

  static func update(password: Data, service: String, account: String) throws {
    let query: [String: Any] = [
      // kSecAttrService,  kSecAttrAccount, and kSecClass
      // uniquely identify the item to update in Keychain
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecClass as String: kSecClassGenericPassword
    ]

    // attributes is passed to SecItemUpdate with
    // kSecValueData as the updated item value
    let attributes: [String: Data] = [
      kSecValueData as String: password
    ]

    // SecItemUpdate attempts to update the item identified
    // by query, overriding the previous value
    let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

    // errSecItemNotFound is a special status indicating the
    // item to update does not exist. Throw itemNotFound so
    // the client can determine whether or not to handle
    // this as an error
    guard status != errSecItemNotFound else {
      throw KeychainError.itemNotFound
    }

    // Any status other than errSecSuccess indicates the
    // update operation failed.
    guard status == errSecSuccess else {
      throw KeychainError.unexpectedStatus(status)
    }
  }

  static func read(service: String, account: String) throws -> Data {
    let query: [String: Any] = [
      // kSecAttrService,  kSecAttrAccount, and kSecClass
      // uniquely identify the item to read in Keychain
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecClass as String: kSecClassGenericPassword,

      // kSecMatchLimitOne indicates keychain should read
      // only the most recent item matching this query
      kSecMatchLimit as String: kSecMatchLimitOne,

      // kSecReturnData is set to kCFBooleanTrue in order
      // to retrieve the data for the item
      kSecReturnData as String: kCFBooleanTrue ?? true
    ]

    // SecItemCopyMatching will attempt to copy the item
    // identified by query to the reference itemCopy
    var itemCopy: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &itemCopy)

    // errSecItemNotFound is a special status indicating the
    // read item does not exist. Throw itemNotFound so the
    // client can determine whether or not to handle
    // this case
    guard status != errSecItemNotFound else {
      throw KeychainError.itemNotFound
    }

    // Any status other than errSecSuccess indicates the
    // read operation failed.
    guard status == errSecSuccess else {
      throw KeychainError.unexpectedStatus(status)
    }

    // This implementation of KeychainInterface requires all
    // items to be saved and read as Data. Otherwise,
    // invalidItemFormat is thrown
    guard let password = itemCopy as? Data else {
      throw KeychainError.invalidItemFormat
    }

    return password
  }

  static func delete(service: String, account: String) throws {
    let query: [String: Any] = [
      // kSecAttrService,  kSecAttrAccount, and kSecClass
      // uniquely identify the item to delete in Keychain
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecClass as String: kSecClassGenericPassword
    ]

    // SecItemDelete attempts to perform a delete operation
    // for the item identified by query. The status indicates
    // if the operation succeeded or failed.
    let status = SecItemDelete(query as CFDictionary)

    // Any status other than errSecSuccess indicates the
    // delete operation failed.
    guard status == errSecSuccess else {
      throw KeychainError.unexpectedStatus(status)
    }
  }
}

enum PinentryMacError: Error {
  // pinetry-mac returned ERR
  case common(String?)

  // pinetry-mac returned unknown output type
  case unexpectedOutput(String?, String?)
}


// ===============
//   Tools
// ===============
struct IO {
  static func die(_ msg: String) {
    logger.error("\(msg, privacy: .public)")
    print(msg, stderr)
    exit(EXIT_FAILURE)
  }

  @discardableResult
  static func shell(_ cmd: String) throws -> String {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", cmd]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
    task.standardInput = nil

    try task.run()

    return String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)!
  }

  static func auth(_ onErr: () -> String) -> LAContext {
    let ctx = LAContext()
    if !ctx.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) { die(onErr()) }
    print("OK Pleased to meet you")
    return ctx
  }

  static func passwd(service: String, account: String, _ onErr: (Error) -> String) {
    do {
      let pass = try KeychainStore.read(service: service, account: account)
      guard let pass = String(data: pass, encoding: .utf8) else { exit(EXIT_FAILURE) }

      logger.info("PASSWD:READ - OK")
      print("D \(pass)")
      print("OK")
    }
    catch { die(onErr(error)) }
  }
}


// ============
// Main Logic
// ============
let logger = Logger(subsystem: "org.pgp.pinentry-swift", category: "main")

func main() {
  var kc  = KeychainItem()
  let ctx = IO.auth({ "ERR Your Mac doesn't support deviceOwnerAuthenticationWithBiometrics" })

  while let input = readLine() {
    // ============
    // Debug Input
    // ============
    let (pref, data) = input.separate()
    switch pref {
    case "SETKEYINFO", "SETDESC", "SETPROMPT", "GETPIN", "BYE":
      logger.debug(
        """
        [\(pref, privacy: .public)]\
        \(kc.key.map { "[\($0)]" } ?? "", privacy: .public)\
        \(data.nilIfBlank().map { ": \($0)" } ?? "", privacy: .public)
        """
      )
    default: break
    }

    // ============
    // Handle Commands
    // ============
    switch input {
    case _ where input.hasPrefix("SETKEYINFO"):
      // KeyInfo is always in the form of x/cacheId
      // https://gist.github.com/mdeguzis/05d1f284f931223624834788da045c65#file-info-pinentry-L357-L362
      kc.key = input.components(separatedBy: "/")[1]
      print("OK")
    case _ where input.hasPrefix("SETDESC"):
      guard let descr = input.dropPrefix("SETDESC ").removingPercentEncoding else { continue }

      if let identity = descr.firstMatch(of: /(?<name>.*<(?<email>.*)>)/) {
        kc.name = String(identity.name).trimmingCharacters(in: CharacterSet(charactersIn: "\"")).components(separatedBy: " <")[0]
        kc.email = String(identity.email)

        if let key = descr.firstMatch(of: /ID (?<key>.*),/).map({ String($0.key) }) {
          // Drop the optional 0x prefix from keyID (--keyid-format) https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
          kc.ssh = key.dropPrefix("0x")
        }
      } else {
        if let key = descr.firstMatch(of: /(?:SHA[0-9]{1,4}|MD5):(?<key>.*)/).map({ String($0.key) }) {
          kc.ssh = key
        }
      }

      print("OK")
    case _ where input.hasPrefix("SETPROMPT"):
      print("OK")
    case _ where input.hasPrefix("GETPIN"):
      guard let account = kc.key else { exit(EXIT_FAILURE) }

      guard let exists = try? KeychainStore.exists(service: kc.service, account: account) else { exit(EXIT_FAILURE) }
      logger.debug("PASSWD:EXISTS - \(exists)")
      if exists {
        ctx.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: kc.describe()) { success, error in
          if success {
            IO.passwd(service: kc.service, account: account, { (e) in "ERR Failed to read passphrase from macOS Keychain (\(e))" })
          } else {
            IO.die("ERR \(error?.localizedDescription ?? "Failed to authenticate")")
          }
        }
      } else {
        do {
          let cmd = try IO.shell("echo GETPIN | /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac")
            .firstMatch(of: /(D|ERR) (.*)/)
            .map { (type: String($0.1), output: String($0.2)) }

          switch (cmd?.type, cmd?.output ?? "") {
          case ("D", let out):
            do {
              try KeychainStore.save(
                label: kc.label(),
                service: kc.service,
                account: account,
                password: out.data(using: .utf8)!
              )
              logger.info("PASSWD:CREATE - OK")
            } catch { exit(EXIT_FAILURE) }

            IO.passwd(service: kc.service, account: account, { (e) in "ERR Failed to read passphrase from macOS Keychain (\(e))" })
          case ("ERR", let out):
            throw PinentryMacError.common(out.replacingOccurrences(of: " <Pinentry>", with: "").nilIfBlank())
          case let (type, out):
            throw PinentryMacError.unexpectedOutput(type, out)
          }
        }
        catch { IO.die("ERR Failed to get password from PinentryMac (\(error))") }
      }
    case _ where input.hasPrefix("BYE"):
      print("OK closing connection")
      exit(EXIT_SUCCESS)
    default:
      print("OK")
    }
  }

  dispatchMain()
}

setbuf(__stdoutp, nil)
main()
