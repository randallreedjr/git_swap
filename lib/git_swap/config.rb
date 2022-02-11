require 'yaml'

module GitSwap
  class Config
    attr_reader :profiles, :selected_profile
    def initialize(args)
      @profiles = load!
      @args = args
      @selected_profile = get_profile(args)
    end

    def get_profile(args)
      args.detect {|a| !a.start_with? '-'}
    end

    def username
      profiles[selected_profile]["username"]
    end

    def email
      profiles[selected_profile]["email"]
    end

    def name
      profiles[selected_profile]["name"]
    end

    def ssh
      profiles[selected_profile]["ssh"]
    end

    def ssh_command
      "ssh -i #{ssh}"
    end

    def profile
      @selected_profile
    end

    def valid_profile?
      if profiles.has_key?(selected_profile)
        return true
      else
        puts "Profile '#{selected_profile}' not found!"
        return false
      end
    end

    def configure!
      @profiles = build_profiles
      write_profiles_to_config_file if @profiles.any?
    end

    def edit!
      # We are using the same message as git rebase -i
      print "hint: Waiting for your editor to close the file..."
      system("#{ENV['EDITOR']} '#{File.expand_path('~/.gitswap')}'")
    end

    def build_profiles
      puts "How many profiles would you like to create?"
      profile_count = STDIN.gets.chomp.to_i
      profiles = Array.new(profile_count, {})
      current = 1
      profiles.map do |profile|
        puts "\n#{ordinal(current)} profile name (e.g. 'work' or 'personal'):"
        profile[:profile_name] = STDIN.gets.chomp
        puts "Git username for #{profile[:profile_name]}:"
        profile[:git_username] = STDIN.gets.chomp
        puts "Git email for #{profile[:profile_name]}:"
        profile[:git_email] = STDIN.gets.chomp
        puts "Git name for #{profile[:profile_name]}:"
        profile[:git_name] = STDIN.gets.chomp
        puts "Path to ssh key for #{profile[:profile_name]} (e.g. '~/.ssh/id_rsa'):"
        profile[:ssh_key] = STDIN.gets.chomp

        current +=1
        profile.dup
      end
    rescue Interrupt
      return {}
    end

    def ordinal(number)
      # Source: https://github.com/infertux/ordinalize_full
      abs_number = number.abs
      suffix = if (11..13).cover?(abs_number % 100)
        "th"
      else
        case abs_number % 10
        when 1 then "st"
        when 2 then "nd"
        when 3 then "rd"
        else "th"
        end
      end
      "#{abs_number}#{suffix}"
    end

    def write_profiles_to_config_file
      File.open(File.expand_path('~/.gitswap'), 'w') do |file|
        profiles.each do |profile|
          file.write "#{profile[:profile_name]}:\n"
          file.write "  username: #{profile[:git_username]}\n"
          file.write "  email: #{profile[:git_email]}\n"
          file.write "  name: #{profile[:git_name]}\n"
          file.write "  ssh: #{profile[:ssh_key]}\n"
        end
      end
    end

    def print_list
      profiles = @profiles.map do |key, value|
        prefix = value["username"] == current_git_username ? "=>" : "  "
        "#{prefix} #{key}"
      end
      puts profiles
      puts "\n# => - current" if @profiles.any? {|key, value| value["username"] == current_git_username}
    end

    private

    def load!
      # If configuration file hasn't been created yet, load an empty hash
      return {} unless File.file?(File.expand_path('~/.gitswap'))
      YAML.load_file(File.expand_path('~/.gitswap')) || {}
    end

    def current_git_username
      `git config user.username`.chomp
    end
  end
end
