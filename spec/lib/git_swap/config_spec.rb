require 'spec_helper'

RSpec.describe GitSwap::Config do
  describe 'profile attributes' do
    let(:config) { GitSwap::Config.new(['personal']) }

    describe '#username' do
      it 'returns the username for the selected profile' do
        expect(config.username).to eq 'johnnyfive'
      end
    end

    describe '#email' do
      it 'returns the email for the selected profile' do
        expect(config.email).to eq 'me@johnsmith.com'
      end
    end

    describe '#name' do
      it 'returns the name for the selected profile' do
        expect(config.name).to eq 'Johnny Smith'
      end
    end

    describe '#ssh' do
      it 'returns the ssh path for the selected profile' do
        expect(config.ssh).to eq '~/.ssh/id_rsa'
      end
    end

    describe '#ssh_command' do
      it 'returns the ssh command for the selected profile' do
        expect(config.ssh_command).to eq 'ssh -i ~/.ssh/id_rsa'
      end
    end
  end

  describe 'valid_profile?' do
    context 'when profile is configured' do
      let(:config) { GitSwap::Config.new(['personal']) }
      it 'returns true' do
        expect(config.valid_profile?).to be true
      end
    end

    context 'when profile is not configured' do
      let(:config) { GitSwap::Config.new(['foo']) }
      let(:expected_output) { "Profile 'foo' not found!\n" }
      it 'returns false' do
        expect(config.valid_profile?).to be false
      end

      it 'prints error message' do
        expect{config.valid_profile?}.to output(expected_output).to_stdout
      end
    end
  end

  describe 'configure!' do
    let(:profile_count) { '2' }
    let(:profile_name_1) { 'work2' }
    let(:git_username_1) { 'johnsmith2' }
    let(:git_email_1) { 'john@defmethod2.io' }
    let(:git_name_1) { 'John Smith Jr' }
    let(:ssh_key_path_1) { '~/.ssh/defmethod2_rsa' }

    let(:profile_name_2) { 'personal2' }
    let(:git_username_2) { 'johnnyfive2' }
    let(:git_email_2) { 'me@johnsmith2.com' }
    let(:git_name_2) { 'Johnny Smith Jr' }
    let(:ssh_key_path_2) { '~/.ssh/id2_rsa' }

    before :each do
      allow(File).to receive(:expand_path).and_return(File.expand_path('spec/fixtures/.empty'))
      @config = GitSwap::Config.new(['-c'])

      io_obj = double
      expect(STDIN)
        .to receive(:gets)
        .and_return(io_obj)
        .exactly(11).times
      expect(io_obj).to receive(:chomp).and_return(profile_count)
      expect(io_obj).to receive(:chomp).and_return(profile_name_1)
      expect(io_obj).to receive(:chomp).and_return(git_username_1)
      expect(io_obj).to receive(:chomp).and_return(git_email_1)
      expect(io_obj).to receive(:chomp).and_return(git_name_1)
      expect(io_obj).to receive(:chomp).and_return(ssh_key_path_1)

      expect(io_obj).to receive(:chomp).and_return(profile_name_2)
      expect(io_obj).to receive(:chomp).and_return(git_username_2)
      expect(io_obj).to receive(:chomp).and_return(git_email_2)
      expect(io_obj).to receive(:chomp).and_return(git_name_2)
      expect(io_obj).to receive(:chomp).and_return(ssh_key_path_2)

      expect(@config).to receive(:puts).with('How many profiles would you like to create?')
      expect(@config).to receive(:puts).with("\n1st profile name (e.g. 'work' or 'personal'):")
      expect(@config).to receive(:puts).with('Git username for work2:')
      expect(@config).to receive(:puts).with('Git email for work2:')
      expect(@config).to receive(:puts).with('Git name for work2:')
      expect(@config).to receive(:puts).with('Path to ssh key for work2 (e.g. \'~/.ssh/id_rsa\'):')

      expect(@config).to receive(:puts).with("\n2nd profile name (e.g. 'work' or 'personal'):")
      expect(@config).to receive(:puts).with('Git username for personal2:')
      expect(@config).to receive(:puts).with('Git email for personal2:')
      expect(@config).to receive(:puts).with('Git name for personal2:')
      expect(@config).to receive(:puts).with('Path to ssh key for personal2 (e.g. \'~/.ssh/id_rsa\'):')
    end

    it 'creates the .gitswap config file' do
      allow(@config).to receive(:write_profiles_to_config_file)
      @config.configure!
      expect(@config.profiles).to eq [
        { :profile_name=>"work2",
          :git_username=>"johnsmith2",
          :git_email=>"john@defmethod2.io",
          :git_name=>"John Smith Jr",
          :ssh_key=>"~/.ssh/defmethod2_rsa" },
        { :profile_name=>"personal2",
          :git_username=>"johnnyfive2",
          :git_email=>"me@johnsmith2.com",
          :git_name=>"Johnny Smith Jr",
          :ssh_key=>"~/.ssh/id2_rsa" }
      ]
    end

    it 'writes the config to the file' do
      expect(File).to receive(:open).with(File.expand_path('~/.gitswap'), 'w')
      @config.configure!
    end
  end

  describe 'edit!' do
    let(:config) { GitSwap::Config.new(['-e']) }
    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('EDITOR').and_return('code -w')
    end

    it 'opens the config file in the editor' do
      expect(config).to receive(:system).with("code -w '#{File.expand_path('spec/fixtures/.gitswap')}'")
      config.edit!
    end
  end

  describe 'ordinal' do
    let(:config) { GitSwap::Config.new(['-c']) }

    it 'returns the correct value for 1' do
      expect(config.ordinal(1)).to eq '1st'
    end

    it 'returns the correct value for 2' do
      expect(config.ordinal(2)).to eq '2nd'
    end

    it 'returns the correct value for 3' do
      expect(config.ordinal(3)).to eq '3rd'
    end

    it 'returns the correct value for 4' do
      expect(config.ordinal(4)).to eq '4th'
    end

    it 'returns the correct value for 10' do
      expect(config.ordinal(10)).to eq '10th'
    end

    it 'returns the correct value for 11' do
      expect(config.ordinal(11)).to eq '11th'
    end

    it 'returns the correct value for 13' do
      expect(config.ordinal(13)).to eq '13th'
    end
  end

  describe '#print_list' do
    let(:config) { GitSwap::Config.new(['-l']) }
    context 'when profiles have been configured' do
      context 'when no profiles are active' do
        let(:expected_output) { "   personal\n   work\n" }
        it 'outputs available profiles' do
          expect{config.print_list}.to output(expected_output).to_stdout
        end
      end

      context 'when a profile is active' do
        before do
          allow(config).to receive(:current_git_username).and_return('johnnyfive')
        end
        let(:expected_output) { "=> personal\n   work\n\n# => - current\n" }
        it 'indicates the active profile' do
          expect{config.print_list}.to output(expected_output).to_stdout
        end
      end
    end

    context 'when no profiles have been configured' do
      let(:expected_output) { '' }
      before do
        # unstub
        allow(File).to receive(:expand_path).and_call_original
        allow(File).to receive(:expand_path).and_return(File.expand_path('spec/fixtures/.empty'))
      end

      it 'outputs an empty string' do
        expect{config.print_list}.to output(expected_output).to_stdout
      end
    end
  end
end
