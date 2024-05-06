# frozen_string_literal: true

module Homebrew
  module_function

  def patch_args
    Homebrew::CLI::Parser.new do
      usage_banner "`patch` [<options>] <tap-user>`/`<tap-repo> <formula>"
      description <<~EOS
        Download Given Formula from `homebrew/core` and Apply Patch from Local Tap
      EOS
      flag   "--ref=",
             description: "Name of Branch/Tag/Ref to download from (default: `HEAD`)."

      named_args :formula, number: 2
    end
  end

  def patch
    args = patch_args.parse
    local_tap = Tap.fetch(args.named.first)
    formula = args.named.second
    ref = args.ref || "HEAD"

    begin
      Utils::Curl.curl_download(
        "#{CoreTap.instance.remote}/raw/#{ref}/Formula/#{formula.chr}/#{formula}.rb",
        "-sS",
        to: "#{local_tap.formula_dir}/#{formula}.rb",
        print_stderr: false
      )

      patched = Utils.popen_read(
        "patch", "#{local_tap.formula_dir}/#{formula}.rb", "#{local_tap.path}/Patches/#{formula}.patch"
      ).lines.first
      if patched.start_with?("patching file '")
        ohai "Sucessfully downloaded and patched `#{formula}.rb`"
      else
        onoe "Failed to patch `#{formula}.rb`: #{patched}"
      end
    rescue ErrorDuringExecution => e
      onoe "Failed to download `#{formula}.rb` #{e.stderr}"
    end
  end
end
