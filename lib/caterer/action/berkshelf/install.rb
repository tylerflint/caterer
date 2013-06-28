require 'digest'

module Caterer
  module Action
    module Berkshelf
      class Install < Base
        
        attr_reader :shelf
        attr_reader :berksfile
        attr_reader :cachefile

        def initialize(app, env)
          super

          @shelf     = Caterer::Berkshelf.shelf_for(env)
          @berksfile = ::Berkshelf::Berksfile.from_file(env[:config].berkshelf.berksfile_path)
          @cachefile = "#{shelf}/.cache"
        end


        def call(env)

          if env[:provisioner].is_a? Caterer::Provisioner::ChefSolo
            configure_cookbooks_path(env[:provisioner])
          end

          if needs_update? or env[:force_berks_install]
            ::Berkshelf.formatter.msg "installing cookbooks..."
            install(env)
            update_cache
          else
            ::Berkshelf.formatter.msg "up-to-date"
          end

          @app.call(env)
        end

        protected

        def shelf_digest
          berks_content = ::File.read(berksfile.filepath) rescue nil
          lock_content  = ::File.read("#{berksfile.filepath}.lock") rescue nil
          shelf_content = ::Dir.glob("#{shelf}/[^\.]*")
          ::Digest::MD5.hexdigest("#{berks_content}/#{lock_content}/#{shelf_content}")
        end

        # default to true for time being...
        def needs_update?
          # !(::File.exists?(cachefile) and ::File.read(cachefile) == shelf_digest)
          true
        end

        def update_cache
          ::File.write(cachefile, shelf_digest)
        end

        def install(env)
          berksfile.install({path: shelf}.merge(env[:config].berkshelf.to_hash).symbolize_keys!)
        end

        def configure_cookbooks_path(provisioner)

          # if for some reason the cookbooks path is a string, convert it into an array
          if not provisioner.cookbooks_path.is_a? Array
            provisioner.cookbooks_path = Array(provisioner.cookbooks_path)
          end

          provisioner.cookbooks_path.unshift(shelf)
        end

      end
    end
  end
end