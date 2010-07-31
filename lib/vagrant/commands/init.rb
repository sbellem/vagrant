module Vagrant
  class Commands
    class Init < Base
      Base.subcommand "init", self
      description "Initializes current folder for Vagrant usage"

      def execute(args)
        if args.empty?
          create_vagrantfile
        else
          create_vagrantfile(:default_box => args[0] , :default_box_url => args[1])
        end 
          
      end

      def options_spec(opts)
        opts.banner = "Usage: vagrant init [name] [box_url]"
      end

      # Actually writes the initial Vagrantfile to the current working directory.
      # The Vagrantfile will contain the base box configuration specified, or
      # will just use "base" if none is specified.
      #
      # @param [String] :default_box The default base box for this
      # Vagrantfile
      # @param [String] :default_box_url The default url for fetching
      # the given box for the Vagrantfile
      def create_vagrantfile(opts={})
        rootfile_path = File.join(Dir.pwd, Environment::ROOTFILE_NAME)
        error_and_exit(:rootfile_already_exists) if File.exist?(rootfile_path)

        # Write the rootfile
        default_opts = { :default_box => "base", :default_box_url => nil}.merge(opts)          

        File.open(rootfile_path, 'w+') do |f|
          f.write(TemplateRenderer.render(Environment::ROOTFILE_NAME, :default_box => default_opts[:default_box], :default_box_url => default_opts[:default_box_url]))
        end
      end
    end
  end
end
