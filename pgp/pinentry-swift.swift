import Foundation
import LocalAuthentication

extension String {
    // Remove a prefix
    func dropPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }

    func match(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSMakeRange(0, nsString.length)).map { match in
            (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
        } ?? []
    }

    // Find matches according to a regular expression
    func matches(_ regex: NSRegularExpression) -> [String] {
        let range = NSRange(self.startIndex..<self.endIndex, in: self)
        let matches = regex.matches(in: self, options: [], range: range)
        var names: [String] = []
        guard let match = matches.first else { return names }
        for rangeIndex in 0..<match.numberOfRanges {
            let matchRange = match.range(at: rangeIndex)
            if matchRange == range { continue }
            if let substringRange = Range(matchRange, in: self) {
                let capture = String(self[substringRange])
                names.append(capture)
            }
        }
        return names
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

    // pinetry-mac returned ERR
    case pinentryFail(String)

    // Unknown error
    case unknown(String)
}

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
      return "access the PIN for ssh key \(sh)"
    }

    return "log in to your account"
  }

  static let keyRegex = try! NSRegularExpression(pattern: "ID (?<keyId>.*),")
  static let emailRegex = try! NSRegularExpression(pattern: "\"(?<name>.*<(?<email>.*)>)\"")
  static let sshRegex = try! NSRegularExpression(pattern: "(?:SHA[0-9]{1,4}|MD5):(?<keyId>.*)")
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

    static func save(password: Data, service: String, account: String) throws {
        let query: [String: Any] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to save in Keychain
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

struct IO {
    static let logFile = FileManager.default
        .urls(for: .libraryDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("Logs", isDirectory: true)
        .appendingPathComponent("pinentry-swift.log")

    static func log(_ input: String...) {
        if FileManager.default.fileExists(atPath: logFile.path) {
            if let handle = try? FileHandle(forWritingTo: logFile) {
                handle.seekToEndOfFile()
                handle.write(input.joined(separator: "\n").data(using: .utf8)!)
                handle.write("\n".data(using: .utf8)!)
                handle.closeFile()
            }
        } else {
            try? input.joined(separator: "\n").data(using: .utf8)?.write(to: logFile)
        }
    }

    @discardableResult // Add to suppress warnings when you don't want/need a result
    static func shell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
        task.standardInput = nil

        try task.run()

        return String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)!
    }
}

func main() {
    var kc = KeychainItem()
    let ctx = LAContext()
    guard ctx.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else {
        IO.log("ERR Your Mac doesn't support deviceOwnerAuthenticationWithBiometrics")
        print("ERR Your Mac doesn't support deviceOwnerAuthenticationWithBiometrics", stderr)
        exit(EXIT_FAILURE)
    }
    
    print("OK Pleased to meet you")

    while let input = readLine() {
        switch input {
        case _ where input.hasPrefix("SETKEYINFO"):
            // KeyInfo is always in the form of x/cacheId
            // https://gist.github.com/mdeguzis/05d1f284f931223624834788da045c65#file-info-pinentry-L357-L362
            kc.key = input.components(separatedBy: "/")[1]
            IO.log("SETKEYINFO", kc.key ?? ">EMPTY<")
            print("OK")
        case _ where input.hasPrefix("SETDESC"):
            IO.log("SETDESC", input.dropPrefix("SETDESC"))

            guard let description = input.dropPrefix("SETDESC ").removingPercentEncoding else { continue }

            var matches = description.matches(KeychainItem.emailRegex)
            if matches.count > 2 {
                kc.name = matches[1].components(separatedBy: " <")[0]
                kc.email = matches[2]

                matches = description.matches(KeychainItem.keyRegex)
                if matches.count > 1 {
                  // Drop the optional 0x prefix from keyID (--keyid-format) https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
                  kc.ssh = matches[1].dropPrefix("0x")
                }
            } else {
                matches = description.matches(KeychainItem.sshRegex)
                if matches.count > 1 {
                  kc.ssh = matches[1]
                }
            }

            print("OK")
        case _ where input.hasPrefix("SETPROMPT"):
            IO.log("SETPROMPT", input.dropPrefix("SETPROMPT"))
            print("OK")
        case _ where input.hasPrefix("GETPIN"):
            IO.log("GETPIN", kc.key ?? ">EMPTY<")

            guard let account = kc.key else { exit(EXIT_FAILURE) }

            ctx.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: kc.describe()) { success, error in
                if success {
                    do {
                        if try KeychainStore.exists(service: kc.service, account: account) {
                            let password = try KeychainStore.read(service: kc.service, account: account)
                            guard let password = String(data: password, encoding: .utf8) else { exit(EXIT_FAILURE) }
                            IO.log("Password Sucessfully Read")
                            print("D \(password)")
                            print("OK")
                        } else {
                            IO.log("Password Not Exists, Creating")

                            do {
                                let cmd = try IO.shell("echo GETPIN | /usr/local/MacGPG2/libexec/pinentry-mac.app/Contents/MacOS/pinentry-mac")
                                    .firstMatch(of: /(D|ERR) (.*)/)
                                    .map { (type: String($0.1), output: String($0.2)) }

                                switch cmd?.type {
                                case "D":
                                    try KeychainStore.save(password: (cmd?.output ?? "").data(using: .utf8)!, service: kc.service, account: account)
                                    IO.log("Password Sucessfully Created")

                                    let password = try KeychainStore.read(service: kc.service, account: account)
                                    guard let password = String(data: password, encoding: .utf8) else { exit(EXIT_FAILURE) }
                                    IO.log("Password Sucessfully Read")
                                    print("D \(password)")

                                    print("OK")
                                case "ERR":
                                    throw KeychainError.pinentryFail(cmd?.output ?? "n/a")
                                default:
                                    throw KeychainError.unknown("[\(cmd?.type ?? "n/a")]: \(cmd?.output ?? "No Output")")
                                }
                            }
                            catch {
                                IO.log("ERR Failed to get password \(error)")
                                print("ERR Failed to get password \(error)", stderr)
                                exit(EXIT_FAILURE)
                            }
                        }
                    } catch {
                        IO.log("ERR Failed to read passphrase from MacOS Keychain (\(error))")
                        print("ERR Failed to read passphrase from MacOS Keychain (\(error))", stderr)
                        exit(EXIT_FAILURE)
                    }
                } else {
                    IO.log("ERR \(error?.localizedDescription ?? "Failed to authenticate")")
                    print("ERR \(error?.localizedDescription ?? "Failed to authenticate")", stderr)
                    exit(EXIT_FAILURE)
                }
            }
        case _ where input.hasPrefix("BYE"):
            print("OK closing connection")
            exit(EXIT_SUCCESS)
        default:
            // IO.log(input)
            print("OK")
        }
    }
    
    dispatchMain()
}

setbuf(__stdoutp, nil)
main()
