[![CircleCI](https://circleci.com/gh/randallreedjr/git_swap.svg?style=shield)](https://circleci.com/gh/randallreedjr/git_swap)
[![Gem Version](https://badge.fury.io/rb/git_swap.svg)](https://badge.fury.io/rb/git_swap)

# Git Swap

**Git Switch is now Git Swap. Due to git releasing a native `switch` command, the gem has been renamed.**

Git Swap is a command line utility to easily swap between multiple git profiles. It uses a `.gitswap` YAML file to configure each profile (name, username, and email) and ssh key.

## Prerequisites

This gem has been developed for, and only tested on, Mac OS.

Additionally, it requires git version 2.10+. Run `git --version` to check your currently install version. If you are using homebrew, you can install a newer version of git with `brew upgrade git`.

## Installation

This gem is not intended to be installed via a Gemfile. Instead, install it yourself:

```
$ gem install git_swap
```

If you use rvm, you can save yourself from some headaches by installing git_swap for all gemsets.

```
$ rvm @global do gem install git_swap
```

If transitioning from `git_swap`, version 0.5.0 or earlier, to `git_swap` version 1.0.0 or later, run this command to preserve your current configuration.

```
cp ~/.gitswitch ~/.gitswap && rm ~/.gitswitch
```

## Configuration

To run the guided setup, use `git swap --config`.

You may also manually create or edit your configuration at `~/.gitswap`. The config file is in YAML format. Here is an example.

```
personal:
  username: johnnyfive
  email: me@johnsmith.com
  name: Johnny Smith
  ssh: ~/.ssh/id_rsa
work:
  username: johnsmith
  email: john@defmethod.io
  name: John Smith
  ssh: ~/.ssh/defmethod_rsa
```

Note that the ssh key must already exist. See these instructions to [generate a new SSH key](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/).

The root keys can be any nickname you want. It should be memorable to make it easy to swap between profiles.

## Usage

Git Swap follows the convention to create a custom git command. It can be invoked as follows, to either set your git profile locally (no flag) or globally (`-g`):

```
$ git swap personal
$ git swap personal -g
```

Note that in previous versions, invoking `git swap` would remove all identities from `ssh-add`, except the one specified. You can always readd them using `ssh-add path/to/ssh`.

Newer versions use git config to specify which ssh identity to use when running git commands.

### Flags

* Use `-l` or `--list` to list configured profiles
```
git swap -l
```

* Use `-v` or `--verbose` to print more detailed output
```
git swap personal -v
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
