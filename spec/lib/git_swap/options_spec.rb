require 'spec_helper'

RSpec.describe GitSwap::Options do
  let(:options) { GitSwap::Options.new(args) }

  describe 'flags' do
    context 'when short flags are used' do
      context 'when run in config mode' do
        let(:args) { ['-c'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['-c']
        end
      end

      context 'when run in edit mode' do
        let(:args) { ['-e'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['-e']
        end
      end

      context 'when run in list mode' do
        let(:args) { ['-l'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['-l']
        end
      end

      context 'when run in version mode' do
        let(:args) { ['-v'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['-v']
        end
      end

      context 'when run in verbose mode' do
        let(:args) { ['-v', 'personal'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['-v']
        end
      end

      context 'when run in global mode' do
        let(:args) { ['personal', '-g'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['-g']
        end
      end

      context 'when run with multiple flags' do
        let(:args) { ['personal', '-g', '-v'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['-g', '-v']
        end
      end

      context 'when run with invalid flags' do
        let(:args) { ['personal', '-a', '-gv'] }
        it 'returns an empty array' do
          expect(options.flags).to eq []
        end
      end
    end

    context 'when long flags are used' do
      context 'when run in config mode' do
        let(:args) { ['--config'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['--config']
        end
      end

      context 'when run in edit mode' do
        let(:args) { ['--edit'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['--edit']
        end
      end

      context 'when run in list mode' do
        let(:args) { ['--list'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['--list']
        end
      end

      context 'when run in version mode' do
        let(:args) { ['--version'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['--version']
        end
      end

      context 'when run in verbose mode' do
        let(:args) { ['--verbose', 'personal'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['--verbose']
        end
      end

      context 'when run in global mode' do
        let(:args) { ['personal', '--global'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['--global']
        end
      end

      context 'when run with multiple flags' do
        let(:args) { ['personal', '--global', '--verbose'] }
        it 'returns an array of the flags' do
          expect(options.flags).to eq ['--global', '--verbose']
        end
      end

      context 'when run with invalid flags' do
        let(:args) { ['personal', '--foo', '--globalist'] }
        it 'returns an empty array' do
          expect(options.flags).to eq []
        end
      end
    end

    context 'when run with no flags' do
      let(:args) { ['personal'] }
      it 'returns an empty array' do
        expect(options.flags).to eq []
      end
    end
  end

  describe 'valid_args?' do
    let(:expected_error) { "Invalid args\n" }

    context 'when run with a single profile' do
      let(:args) { ['personal'] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end

    context 'when run with a profile and a flag' do
      let(:args) { ['personal', '-g'] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end

    context 'when run with a profile and non-profile flag' do
      let(:args) { ['personal', '-l'] }

      it 'returns false' do
        expect(options.valid_args?).to be false
      end

      it 'prints error message' do
        expect{options.valid_args?}.to output(expected_error).to_stdout
      end
    end

    context 'when run with config flag' do
      let(:args) { ['-c'] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end

    context 'when run with edit flag' do
      let(:args) { ['-e'] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end

    context 'when run with list flag' do
      let(:args) { ['-l'] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end

    context 'when run with version flag' do
      let(:args) { ['-v'] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end

    context 'when run with version flag with profile' do
      let(:args) { ['--version', 'personal'] }

      it 'returns false' do
        expect(options.valid_args?).to be false
      end

      it 'prints error message' do
        expect{options.valid_args?}.to output(expected_error).to_stdout
      end
    end

    context 'when run with verbose flag with profile' do
      let(:args) { ['-v', 'personal'] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end

    context 'when run with verbose flag without profile' do
      let(:args) { ['--verbose'] }

      it 'returns false' do
        expect(options.valid_args?).to be false
      end

      it 'prints error message' do
        expect{options.valid_args?}.to output(expected_error).to_stdout
      end
    end

    context 'when run with multiple flags' do
      let(:args) { ['personal','-g','-l'] }
      let(:options) { GitSwap::Options.new(args) }

      it 'returns false' do
        expect(options.valid_args?).to be false
      end

      it 'prints error message' do
        expect{options.valid_args?}.to output(expected_error).to_stdout
      end
    end

    context 'when run with multiple profiles' do
      let(:args) { ['personal','work'] }

      it 'returns false' do
        expect(options.valid_args?).to be false
      end

      it 'prints error message' do
        expect{options.valid_args?}.to output(expected_error).to_stdout
      end
    end

    context 'when run with no args' do
      let(:args) { [] }

      it 'returns true' do
        expect(options.valid_args?).to be true
      end
    end
  end

  describe 'usage?' do
    context 'when there are no args' do
      let(:args) { [] }
      it 'returns true' do
        expect(options.usage?).to be true
      end
    end

    context 'with a profile' do
      let(:args) { ['foo'] }
      it 'returns false' do
        expect(options.usage?).to be false
      end
    end

    context 'with a flag' do
      let(:args) { ['-l'] }
      it 'returns false' do
        expect(options.usage?).to be false
      end
    end
  end

  describe 'config?' do
    context 'when args includes -c' do
      let(:args) { ['-c'] }
      it 'returns true' do
        expect(options.config?).to be true
      end
    end

    context 'when args includes --config' do
      let(:args) { ['--config'] }
      it 'returns true' do
        expect(options.config?).to be true
      end
    end

    context 'when there are multiple args' do
      let(:args) { ['-c', 'foo'] }
      it 'returns false' do
        expect(options.config?).to be false
      end
    end

    context 'when args do not include -c or --config' do
      let(:args) { [] }
      it 'returns false' do
        expect(options.config?).to be false
      end
    end
  end

  describe 'edit?' do
    context 'when args includes -e' do
      let(:args) { ['-e'] }
      it 'returns true' do
        expect(options.edit?).to be true
      end
    end

    context 'when args includes --edit' do
      let(:args) { ['--edit'] }
      it 'returns true' do
        expect(options.edit?).to be true
      end
    end

    context 'when there are multiple args' do
      let(:args) { ['-e', 'foo'] }
      it 'returns false' do
        expect(options.edit?).to be false
      end
    end

    context 'when args do not include -e or --edit' do
      let(:args) { [] }
      it 'returns false' do
        expect(options.edit?).to be false
      end
    end
  end

  describe 'list?' do
    context 'when args includes -l' do
      let(:args) { ['-l'] }
      it 'returns true' do
        expect(options.list?).to be true
      end
    end

    context 'when args includes --list' do
      let(:args) { ['--list'] }
      it 'returns true' do
        expect(options.list?).to be true
      end
    end

    context 'when there are multiple args' do
      let(:args) { ['-l', 'foo'] }
      it 'returns false' do
        expect(options.list?).to be false
      end
    end

    context 'when args do not include -l or --list' do
      let(:args) { [] }
      it 'returns false' do
        expect(options.list?).to be false
      end
    end
  end

  describe 'version?' do
    context 'when args includes -v' do
      let(:args) { ['-v'] }
      it 'returns true' do
        expect(options.version?).to be true
      end
    end

    context 'when args includes --version' do
      let(:args) { ['--version'] }
      it 'returns true' do
        expect(options.version?).to be true
      end
    end

    context 'when args include -v and a profile' do
      let(:args) { ['-v', 'personal'] }
      it 'returns false' do
        expect(options.version?).to be false
      end
    end

    context 'when args include --version and a profile' do
      let(:args) { ['--version', 'personal'] }
      it 'returns false' do
        expect(options.version?).to be false
      end
    end

    context 'when args do not include -v or --version' do
      let(:args) { [] }
      it 'returns false' do
        expect(options.version?).to be false
      end
    end
  end

  describe 'verbose?' do
    context 'when args includes -v' do
      let(:args) { ['-v', 'personal'] }
      it 'returns true' do
        expect(options.verbose?).to be true
      end
    end

    context 'when args includes --verbose' do
      let(:args) { ['--verbose', 'personal'] }
      it 'returns true' do
        expect(options.verbose?).to be true
      end
    end

    context 'when args include -v and no profile' do
      let(:args) { ['-v'] }
      it 'returns false' do
        expect(options.verbose?).to be false
      end
    end

    context 'when args include --verbose and no profile' do
      let(:args) { ['--verbose'] }
      it 'returns false' do
        expect(options.verbose?).to be false
      end
    end

    context 'when args do not include -v or --version' do
      let(:args) { [] }
      it 'returns false' do
        expect(options.version?).to be false
      end
    end
  end

  describe 'global?' do
    context 'when args includes -g' do
      let(:args) { ['-g'] }
      it 'returns true' do
        expect(options.global?).to be true
      end
    end

    context 'when args includes --global' do
      let(:args) { ['--global'] }
      it 'returns true' do
        expect(options.global?).to be true
      end
    end

    context 'when args do not include -g or --global' do
      let(:args) { [] }
      it 'returns false' do
        expect(options.global?).to be false
      end
    end
  end

  describe 'verbose?' do
    context 'when args includes -v' do
      let(:args) { ['-v', 'personal'] }
      it 'returns true' do
        expect(options.verbose?).to be true
      end
    end

    context 'when args includes --verbose' do
      let(:args) { ['--verbose', 'personal'] }
      it 'returns true' do
        expect(options.verbose?).to be true
      end
    end

    context 'when args do not include -v or --verbose' do
      let(:args) { [] }
      it 'returns false' do
        expect(options.verbose?).to be false
      end
    end
  end
end
