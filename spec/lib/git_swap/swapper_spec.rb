require 'spec_helper'

RSpec.describe GitSwap::Swapper do
  describe '#global?' do
    context 'when -g is passed as first argument' do
      it 'sets to true' do
        expect(GitSwap::Swapper.new(['-g','foo']).global?).to be true
      end
    end

    context 'when -g is passed as second argument' do
      it 'sets to true' do
        expect(GitSwap::Swapper.new(['foo','-g']).global?).to be true
      end
    end

    context 'when --global is passsed as first argument' do
      it 'sets to true' do
        expect(GitSwap::Swapper.new(['--global','foo']).global?).to be true
      end
    end

    context 'when --global is passsed as second argument' do
      it 'sets to true' do
        expect(GitSwap::Swapper.new(['foo','--global']).global?).to be true
      end
    end

    context 'when no flag is passed' do
      it 'sets to false' do
        expect(GitSwap::Swapper.new(['foo']).global?).to be false
      end
    end
  end

  describe '#profile' do
    context 'when profile is only argument' do
      it 'sets correctly' do
        expect(GitSwap::Swapper.new(['foo']).profile).to eq 'foo'
      end
    end

    context 'when profile is first argument' do
      it 'sets correctly' do
        expect(GitSwap::Swapper.new(['foo1','-g']).profile).to eq 'foo1'
      end
    end

    context 'when profile is second argument' do
      it 'sets correctly' do
        expect(GitSwap::Swapper.new(['--global','foo2']).profile).to eq 'foo2'
      end
    end
  end

  describe '#config?' do
    context 'when -c is passed as only argument' do
      it 'returns true' do
        expect(GitSwap::Swapper.new(['-c']).config?).to be true
      end
    end

    context 'when -c is passed as first argument' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['-c','foo']).config?).to be false
      end
    end

    context 'when -c is passed as second argument' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['foo','-c']).config?).to be false
      end
    end

    context 'when --config is passed as only argument' do
      it 'returns true' do
        expect(GitSwap::Swapper.new(['--config']).config?).to be true
      end
    end

    context 'when --config is passsed as first argument' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['--config', 'foo']).config?).to be false
      end
    end

    context 'when --config is passsed as second argument' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['foo','--config']).config?).to be false
      end
    end

    context 'when no flag is passed' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['foo']).config?).to be false
      end
    end
  end

  describe '#edit?' do
    context 'when -e is passed as only argument' do
      it 'returns true' do
        expect(GitSwap::Swapper.new(['-e']).edit?).to be true
      end
    end

    context 'when -e is passed as first argument' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['-e','foo']).edit?).to be false
      end
    end

    context 'when -e is passed as second argument' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['foo','-e']).edit?).to be false
      end
    end

    context 'when --edit is passed as only argument' do
      it 'returns true' do
        expect(GitSwap::Swapper.new(['--edit']).edit?).to be true
      end
    end

    context 'when --edit is passsed as first argument' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['--edit', 'foo']).edit?).to be false
      end
    end

    context 'when --edit is passsed as second argument' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['foo','--edit']).edit?).to be false
      end
    end

    context 'when no flag is passed' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['foo']).edit?).to be false
      end
    end
  end

  describe '#list?' do
    context 'when -l is passed as only argument' do
      it 'returns true' do
        expect(GitSwap::Swapper.new(['-l']).list?).to be true
      end
    end

    context 'when -l is passed as first argument' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['-l','foo']).list?).to be false
      end
    end

    context 'when -l is passed as second argument' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['foo','-l']).list?).to be false
      end
    end

    context 'when --list is passed as only argument' do
      it 'returns true' do
        expect(GitSwap::Swapper.new(['--list']).list?).to be true
      end
    end

    context 'when --list is passsed as first argument' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['--list', 'foo']).list?).to be false
      end
    end

    context 'when --list is passsed as second argument' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['foo','--list']).list?).to be false
      end
    end

    context 'when no flag is passed' do
      it 'returns false' do
        expect(GitSwap::Swapper.new(['foo']).list?).to be false
      end
    end
  end

  describe '#run' do
    context 'with no args' do
      let(:swapper) { GitSwap::Swapper.new([]) }
      it 'calls print_usage' do
        expect(swapper).to receive(:print_usage)
        swapper.run
      end
    end

    context 'in config mode' do
      let(:swapper) { GitSwap::Swapper.new(['-c']) }
      it 'calls configure!' do
        expect(swapper).to receive(:configure!).and_call_original
        expect(swapper.config).to receive(:configure!)
        swapper.run
      end
    end

    context 'in edit mode' do
      let(:swapper) { GitSwap::Swapper.new(['-e']) }
      it 'calls edit!' do
        expect(swapper).to receive(:edit!).and_call_original
        expect(swapper.config).to receive(:edit!)
        swapper.run
      end
    end

    context 'in list mode' do
      let(:swapper) { GitSwap::Swapper.new(['-l']) }
      it 'calls print_list' do
        expect(swapper).to receive(:print_list).and_call_original
        expect(swapper.config).to receive(:print_list)
        swapper.run
      end
    end

    context 'in version mode' do
      let(:swapper) { GitSwap::Swapper.new(['-v']) }
      it 'calls print_version' do
        expect(swapper).to receive(:print_version)
        swapper.run
      end
    end

    context 'in set mode' do
      let(:swapper) { GitSwap::Swapper.new(['personal']) }
      let(:options) { swapper.options }

      it 'calls set!' do
        expect(swapper).to receive(:set!)
        swapper.run
      end

      it 'checks for valid args' do
        expect(options).to receive(:valid_args?)
        swapper.run
      end

      it 'checks for valid profile' do
        expect(swapper.config).to receive(:valid_profile?)
        swapper.run
      end

      it 'checks for git repo' do
        expect(swapper).to receive(:git_repo?)
        swapper.run
      end
    end

    context 'when profile is missing' do
      let(:swapper) { GitSwap::Swapper.new(['foo']) }
      let(:expected_output) { "Profile 'foo' not found!\n" }
      it 'prints error message' do
        expect{swapper.run}.to output(expected_output).to_stdout
      end
    end
  end

  describe '#set!' do
    before do
      allow(swapper).to receive(:set_git_config) {}
      allow(swapper).to receive(:set_ssh) {}
    end

    let(:swapper) { GitSwap::Swapper.new(['personal']) }

    it 'calls set_git_config' do
      expect(swapper).to receive(:set_git_config)
      swapper.run
    end

    it 'calls set_ssh' do
      expect(swapper).to receive(:set_ssh)
      swapper.run
    end

    it 'calls print_settings' do
      expect(swapper).to receive(:print_settings)
      swapper.run
    end
  end

  describe '#print_settings' do
    context 'when called with --verbose flag' do
      let(:swapper) { GitSwap::Swapper.new(['personal', '--verbose']) }
      it 'prints all settings' do
        expect{swapper.print_settings}.to output(/\nGit Config:/).to_stdout
        expect{swapper.print_settings}.to output(/\nSSH:/).to_stdout
      end
    end
    context 'when called with -v flag' do
      let(:swapper) { GitSwap::Swapper.new(['personal', '--verbose']) }
      it 'prints all settings' do
        expect{swapper.print_settings}.to output(/\nGit Config:/).to_stdout
        expect{swapper.print_settings}.to output(/\nSSH:/).to_stdout
      end
    end
    context 'when called without --verbose or -v flag' do
      let(:swapper) { GitSwap::Swapper.new(['personal']) }
      it 'does  not print all settings' do
        expect{swapper.print_settings}.to_not output(/\nGit Config:/).to_stdout
        expect{swapper.print_settings}.to_not output(/\nSSH:/).to_stdout
      end

      it 'prints confirmation message' do
        expect{swapper.print_settings}.to_not output("/nSwapped to profile personal").to_stdout
      end
    end
  end

  describe '#print_usage' do
    let(:swapper) { GitSwap::Swapper.new([]) }
    let(:expected_output) do
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

    it 'outputs usage details' do
      expect{swapper.print_usage}.to output(expected_output).to_stdout
    end
  end

  describe '#print_version' do
    let(:swapper) { GitSwap::Swapper.new(['-v']) }
    let(:expected_output) { "#{GitSwap::VERSION}\n" }

    it 'outputs usage details' do
      expect{swapper.print_version}.to output(expected_output).to_stdout
    end
  end

  describe 'git_repo?' do
    let(:swapper) { GitSwap::Swapper.new(['personal']) }
    context 'when GitHelper returns true' do
      before do
        allow(GitSwap::GitHelper).to receive(:git_repo?).and_return(File.expand_path('.'))
      end
      it 'returns true' do
        expect(swapper.git_repo?).to be true
      end
    end

    context 'when GitHelper returns nil' do
      before do
        allow(GitSwap::GitHelper).to receive(:git_repo?).and_return(nil)
      end

      context 'when run with global flag' do
        let(:swapper) { GitSwap::Swapper.new(['personal','-g']) }
        it 'returns true' do
          expect(swapper.git_repo?).to be true
        end
      end

      context 'when run without global flag' do
        let(:expected_error) { "Not a git repo. Please run from a git repo or run with `-g` to update global settings.\n" }
        it 'returns false' do
          expect(swapper.git_repo?).to be false
        end

        it 'prints error message' do
          expect{swapper.git_repo?}.to output(expected_error).to_stdout
        end
      end
    end
  end
end
