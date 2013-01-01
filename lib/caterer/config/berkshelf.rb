module Caterer
  module Config
    class Berkshelf
      
      # @return [String]
      #   path to the Berksfile to use with Vagrant
      attr_reader :berksfile_path

      # @return [Array<Symbol>]
      #   only cookbooks in these groups will be installed and copied to
      #   Vagrant's shelf
      attr_accessor :only

      # @return [Array<Symbol>]
      #   cookbooks in all other groups except for these will be installed
      #   and copied to Vagrant's shelf
      attr_accessor :except

      def initialize
        @berksfile_path = File.join(Dir.pwd, ::Berkshelf::DEFAULT_FILENAME)
        @except         = []
        @only           = []
      end

      # @param [String] value
      def berksfile_path=(value)
        @berksfile_path = File.expand_path(value)
      end

      def to_hash
        {
          :berksfile_path => @berksfile_path,
          :only => @only,
          :except => @except
        }
      end

    end
  end
end