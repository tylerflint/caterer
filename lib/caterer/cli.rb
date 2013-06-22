# Credit:
# special thanks to Vagrant project: https://github.com/mitchellh/vagrant
# where parts of this module were extracted

require 'optparse'

module Caterer
  class Cli
    def initialize(argv, env)
      @argv   = argv
      @env    = env
      @logger = Log4r::Logger.new("caterer::cli")
      @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)

      @logger.info("CLI: #{@main_args.inspect} #{@sub_command.inspect} #{@sub_args.inspect}")
    end

    def execute
      if @main_args.include?("-v") || @main_args.include?("--version")
        # Version short-circuits the whole thing. Just print
        # the version and exit.
        @env.ui.info "Caterer version #{Caterer::VERSION}", :prefix => false

        return 0
      elsif @main_args.include?("-h") || @main_args.include?("--help")
        # Help is next in short-circuiting everything. Print
        # the help and exit.
        help
        return 0
      end

      command_class = Caterer.commands.get(@sub_command.to_sym) if @sub_command
      if !command_class || !@sub_command
        help
        return 0
      end
      @logger.debug("Invoking command class: #{command_class} #{@sub_args.inspect}")

      # Initialize and execute the command class, returning the exit status.
      result = command_class.new(@sub_args, @env).execute
      result = 0 if !result.is_a?(Fixnum)
      result
    end

    def help
      opts = OptionParser.new do |opts|
        opts.banner = "Usage: cater [-v] [-h] command [<args>]"
        opts.separator ""
        opts.on("-v", "--version", "Print the version and exit.")
        opts.on("-h", "--help", "Print this help.")
        opts.separator ""
        opts.separator "Available subcommands:"

        # Add the available subcommands as separators in order to print them
        # out as well.
        keys = []
        Caterer.commands.each { |key, value| keys << key.to_s }

        keys.sort.each do |key|
          opts.separator "     #{key}"
        end

        opts.separator ""
        opts.separator "For help on any individual command run `cater COMMAND -h`"
      end

      @env.ui.info opts.help, :prefix => false
    end

    # This method will split the argv given into three parts: the
    # flags to this command, the subcommand, and the flags to the
    # subcommand. For example:
    #
    #     -v status -h -v
    #
    # The above would yield 3 parts:
    #
    #     ["-v"]
    #     "status"
    #     ["-h", "-v"]
    #
    # These parts are useful because the first is a list of arguments
    # given to the current command, the second is a subcommand, and the
    # third are the commands given to the subcommand.
    #
    # @return [Array] The three parts.
    def split_main_and_subcommand(argv)
      # Initialize return variables
      main_args   = nil
      sub_command = nil
      sub_args    = []

      # We split the arguments into two: One set containing any
      # flags before a word, and then the rest. The rest are what
      # get actually sent on to the subcommand.
      argv.each_index do |i|
        if !argv[i].start_with?("-")
          # We found the beginning of the sub command. Split the
          # args up.
          main_args   = argv[0, i]
          sub_command = argv[i]
          sub_args    = argv[i + 1, argv.length - i + 1]

          # Break so we don't find the next non flag and shift our
          # main args.
          break
        end
      end

      # Handle the case that argv was empty or didn't contain any subcommand
      main_args = argv.dup if main_args.nil?

      return [main_args, sub_command, sub_args]
    end

  end
end