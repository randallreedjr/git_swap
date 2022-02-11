require_relative './version'

module GitSwap
  class Swapper
    attr_reader :config, :options

    def initialize(args)
      raise ArgumentError unless args.is_a? Array
      @options = GitSwap::Options.new(args)
      @config = GitSwap::Config.new(args)
    end

    def run
      return unless options.valid_args?
      if usage?
        print_usage
      elsif config?
        configure!
      elsif edit?
        edit!
      elsif list?
        print_list
      elsif version?
        print_version
      else
        set!
      end
    end

    def git_repo?
      if GitHelper.git_repo? || global?
        return true
      else
        puts "Not a git repo. Please run from a git repo or run with `-g` to update global settings."
        return false
      end
    end

    def set!
      return unless valid_profile? && git_repo?

      set_git_config
      set_ssh
      print_settings
    end

    def print_usage
      puts usage
    end

    def print_version
      puts GitSwap::VERSION
    end

    def print_settings
      if options.verbose?
        puts "\nGit Config:"
        puts `git config #{git_config_flag} -l --show-origin | grep user`
        puts "\nSSH:"
        puts `ssh-add -l`
      else
        puts "Swapped to profile #{profile}"
      end
    end

    # Use method_missing for delegation
    # Original ActiveSupport version
    # delegate :usage?, :config?, :edit?, :list?, :version?, :global?, to: :options
    # delegate :profile, :name, :username, :email, :ssh, :ssh_command, :print_list, :configure!, :edit!, :valid_profile?, to: :config
    def method_missing(method, *args)
      if @options.respond_to?(method)
        @options.send(method, *args)
      elsif @config.respond_to?(method)
        @config.send(method, *args)
      else
        super
      end
    end

    private

    def git_config_flag
      @git_config_flag ||= global? ? '--global' : ''
    end

    def set_git_config
      `git config #{git_config_flag} user.name "#{name}"`
      `git config #{git_config_flag} user.username "#{username}"`
      `git config #{git_config_flag} user.email "#{email}"`
    end

    def set_ssh
      `git config #{git_config_flag} core.sshCommand "#{ssh_command}"`
      # Include the --apple-use-keychain option to retrieve the passphrase
      if options.verbose?
        `ssh-add --apple-use-keychain #{ssh}`
      else
        `ssh-add --apple-use-keychain #{ssh} 2>/dev/null`
      end
    end

    def usage
      <<~USAGE
      usage: git swap [-c | --config] [-e | --edit] [-l | --list] [-v | --version]
                        <profile> [-v | --verbose] [-g | --global]

      configure profiles
          git swap -c

      open configuration file in editor
          git swap -e

      swap to a profile for local development only
          git swap <profile>

      swap to a profile globally
          git swap -g <profile>

      swap to a profile and see all output
          git swap -v <profile>

      see available profiles
          git swap -l

      view installed gem version
          git swap -v
      USAGE
    end
  end
end
