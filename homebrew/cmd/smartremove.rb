# frozen_string_literal: true

require "abstract_command"

module Homebrew
  module Cmd
    class Smartremove < AbstractCommand
      cmd_args do
        usage_banner "`smartremove` [<options>] <formula|cask>"
        description <<~EOS
          Intellectually Remove All Unused Dependencies
        EOS
        switch "-v", "--verbose",
               description: "Print calling args and left_deps intersection result."

        named_args :formula
      end

      def left_deps(formula_or_cask, args:)
        deps = Utils.popen_read("brew", "deps", "--include-build", formula_or_cask).chomp.split(" ")
        ohai "Deps #{deps}" if args.verbose?

        leaves = Utils.popen_read("brew", "leaves").chomp.split(" ")
        ohai "Leaves #{leaves}" if args.verbose?

        intersect = deps & leaves
        ohai "Intersect #{intersect}" if args.verbose?

        intersect
      end

      def uninstall(list, args:)
        if list.length > 0
          result = Utils.popen_read("brew", "uninstall", "--zap", *list).chomp
          ohai "Uninstall #{list}\n#{result}"
        end
      end

      def autoremove(args:)
        result = Utils.popen_read("brew", "autoremove").lines.map { |line| line.strip }
        list = result.drop(1).take_while { |line| !line.include? "Uninstalling" }

        if list.length > 0
          ohai "Autoremove #{list}\n#{result.drop(list.length + 1).join("\n")}"
        end

        list
      end

      def run
        formula_or_cask = args.named.first

        begin
          ohai "Called `smartremove #{formula_or_cask}`" if args.verbose?

          before = left_deps(formula_or_cask, args: args)
          uninstall(before, args: args)

          autoremove(args: args)

          after = left_deps(formula_or_cask, args: args)
          uninstall(after, args: args)
        rescue ErrorDuringExecution => e
          odie e
        end
      end
    end
  end
end
