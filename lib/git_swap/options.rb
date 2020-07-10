module GitSwap
  class Options
    attr_reader :args
    def initialize(args)
      @args = args
    end

    def flags
      @flags ||= args.select do |arg|
        arg.match(/\A\-[ceglv]{1}\z/) ||
          arg.match(/\A\-\-(config|edit|global|list|verbose|version){1}\z/)
      end
    end

    def valid_args?
      if config?
        return true
      elsif edit?
        return true
      elsif list?
        return true
      elsif version?
        return true
      elsif verbose?
        return true
      elsif no_flags?
        return true
      elsif one_flag? && !flag_only?
        return true
      elsif usage?
        return true
      else
        puts "Invalid args"
        return false
      end
    end

    def usage?
      args.count == 0
    end

    def config?
      config_flag? && args.count == 1
    end

    def edit?
      edit_flag? && args.count == 1
    end

    def list?
      list_flag? && args.count == 1
    end

    def version?
      version_flag? && args.count == 1
    end

    def global?
      (flags.include? '-g') || (flags.include? '--global')
    end

    def verbose?
      verbose_flag? && args.count > 1
    end

    private

    def config_flag?
      (flags.include? '-c') || (flags.include? '--config')
    end

    def edit_flag?
      (flags.include? '-e') || (flags.include? '--edit')
    end

    def list_flag?
      (flags.include? '-l') || (flags.include? '--list')
    end

    def version_flag?
      ((flags.include? '-v') && args.count == 1) || (flags.include? '--version')
    end

    def verbose_flag?
      ((flags.include? '-v') && args.count > 1) || (flags.include? '--verbose')
    end

    def no_flags?
      args.length == 1 && flag_count(args) == 0
    end

    def one_flag?
      args.length == 2 && flag_count(args) == 1
    end

    def flag_only?
      list_flag? || config_flag? || version_flag?
    end

    def flag_count(args)
      args.count {|a| a.start_with? '-'}
    end
  end
end
