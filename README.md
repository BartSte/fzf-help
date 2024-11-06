# README

<img src="./static/logo.svg" width=50%>

## Contents

<!--toc:start-->

- [Introduction](#introduction)
- [Dependencies](#dependencies)
  - [MacOS](#macos)
- [Installation](#installation)
  - [Manual as root](#manual-as-root)
  - [Manual as user](#manual-as-user)
  - [With package manager](#with-package-manager)
- [Configuration](#configuration)
- [Usage](#usage)
- [Tests](#tests)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
<!--toc:end-->

## Introduction

`fzf-help` is an `fzf` extension that allows you to select command line options
of a given command. The options are retrieved from the command its `--help`
documentation, which is displayed in a preview window. Zsh, bash and fish are
supported. Tested on Linux, but should work on other platforms that support
one of the shells.

![demo](https://media.githubusercontent.com/media/BartSte/fzf-help/refs/heads/21-demo-is-included-during-installation/static/demo.gif)

## Dependencies

Ensure that you have the following tools installed:

- [fzf](https://github.com/junegunn/fzf)
- [bat](https://www.github.com/sharkdp/bat) (optional, but recommended)

On Arch, for example, you can install these tools with:

```zsh
sudo pacman -S fzf bat
```

### MacOS

Ensure that [GNU grep](https://www.gnu.org/software/grep/) is installed and
available either as `ggrep` or `grep`:

```zsh
brew install grep # Installs GNU grep as ggrep
```

## Installation

### Manual as root

After installing the dependencies, run the following bash command to install
`fzf-help` in the `/usr/share/fzf-help` directory:

```bash
bash -c 'tmp_dir=$(mktemp -d); GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/BartSte/fzf-help.git $tmp_dir; $tmp_dir/install; rm -rf $tmp_dir;'
```

The following sections describe how to setup the key bindings for the
supported shells.

#### zsh

After installation, add the following to your `.zshrc` file:

```zsh
source /usr/share/fzf-help/fzf-help.zsh
zle -N fzf-help-widget
bindkey "^A" fzf-help-widget
```

which will bind the `fzf-help-widget` to the `ctrl-a`, which you should trigger
after typing the command you want to get help for.

#### bash

After installation, you can add the following to your `.bashrc` file:

```bash
source /usr/share/fzf-help/fzf-help.bash
bind -x '"\C-a": fzf-help-widget'
```

which will bind the `fzf-help-widget` to the `ctrl-a`, which you should trigger
after typing the command you want to get help for.

#### fish

After installation, you can add the following to your
`~/.config/fish/config.fish` file:

```fish
source /usr/share/fzf-help/fzf-help.fish
bind \ca fzf-help-widget
```

which will bind the `fzf-help-widget` to the `ctrl-a`, which you should trigger
after typing the command you want to get help for.

### Manual as user

Run the following command to install `fzf-help` in the
`$HOME/.local/share/fzf-help` directory. Use this if you do not have root
access.

```bash
bash -c 'tmp_dir=$(mktemp -d); git clone https://github.com/BartSte/fzf-help.git $tmp_dir; $tmp_dir/install --user; rm -rf $tmp_dir;'
```

#### zsh

If you use zsh, add the following to your `.zshrc` file:

```bash
source $HOME/.local/share/fzf-help/fzf-help.zsh
zle -N fzf-help-widget
bindkey "^A" fzf-help-widget
```

#### bash

If you use bash, you can add the following to your `.bashrc` file:

```bash
source $HOME/.local/share/fzf-help/fzf-help.bash
bind -x '"\C-a": fzf-help-widget'
```

#### fish

If you use fish, you can add the following to your
`~/.config/fish/config.fish` file:

```fish
source $HOME/.local/share/fzf-help/fzf-help.fish
bind \ca fzf-help-widget
```

### With package manager

The package managers specified below will install `fzf-help` as root. To
configure the key bindings, follow the instructions in the [Manual as
root](#manual-as-root) section for your shell.

#### Arch Linux

You can install `fzf-help` from the AUR using for example `yay`:

```bash
yay -S fzf-help
```

## Configuration

The following environment variables can be set to configure the behaviour of
`fzf-help`:

- `FZF_HELP_OPTS`: options to pass to `fzf` when selecting the command to get
  help for. Defaults to:

  ```bash
  FZF_HELP_OPTS="--multi --layout=reverse --preview-window=right,75%,wrap --height 80% "
  FZF_HELP_OPTS+="--bind ctrl-a:change-preview-window(down,75%,nowrap|right,75%,nowrap)"
  ```

- `FZF_HELP_SYNTAX`: set this variable to configure the `bat --language=`
  option. It defaults to `txt`. If you use `bat` version 0.21 or higher, you can
  set this variable to:

  ```bash
  export FZF_HELP_SYNTAX='help'
  ```

  to get syntax highlighting for the `--help` documentation. Older versions of
  `bat` do not support this syntax highlighting, therefore the default is `txt`.

- `FZF_HELP_BAT_WARNING`: set this variable to `false` to disable the warning
  that is displayed when `bat` is not installed. Defaults to `true`.

- `HELP_MESSAGE_CMD`: controls which command is used to retrieve the command
  line options. Here, the `$cmd` variable is the command to get the options for.
  Defaults to `$cmd --help`. You can use `man -P cat $cmd` if you want to use the
  man page instead of the `--help` documentation.

- `HELP_MESSAGE_RC`: set this environment variable to a file you want to be
  sourced before getting the help message. Typically, this file will contain
  aliases and functions from which you may want to get the help message. When
  this variable is set, alias expansion is also enabled.

- `CLI_OPTIONS_CMD`: set this environment variable to the command you want to
  use to retrieve the command line options. When defining the command, ensure
  that the output is in the form of: the line number on which the option was
  found, a colon, and the name of the option (including the leading dashes).
  For example:

  ```txt
  line-number:--option1
  line-number:--option2
  line-number:--option3
  ```

  where `line-number` is used to highlight the line in the fzf preview window.
  The default command is:

  ```bash
  grep -o --line-number -P -- $RE
  ```

  where `$RE` is the regular expression that is used to match the command line
  options. You can also add this to your custom command by adding `$RE` in your
  command. For example, if you want to use `ag` instead of `grep`, you can set
  `CLI_OPTIONS_CMD` to:

  ```bash
  export CLI_OPTIONS_CMD='ag -o --numbers -- $RE'
  ```

- `FZF_HELP_LOG`: the path to the log file. Defaults to
  `~/.local/state/fzf-help.log`.

- `FZF_HELP_LOG_LINES`: the number of lines to keep in the log file. Defaults to
  `10000`.

## Usage

As the demo shows, you can use `fzf-help` by typing `ctrl-a` after typing the
command you want to get help for. This will open `fzf` with a list of options
and the `--help` documentation in the preview window. You can press `ctrl-a`
again to toggle the preview window to the bottom or the right of the widget.
This is useful when you do not like page wrapping.

## Tests

To run the test the following submodules need to be installed as git
sub modules:

- Install [bats-core](https://github.com/bats-core/bats-core)
- Install [bats-assert](https://github.com/ztombol/bats-assert)
- Install [bats-support](https://github.com/ztombol/bats-support)

To install these sub modules, run the following commands:

```
git submodule init
git submodule update
```

After this, you can use the `bats` executable in the root of the repository to
run the tests. To run all tests, run:

```bash
./bats test
```

here, `./bats` is a shortcut to `./test/bats/bin/bats`.

For more information, see the [bats-core documentation](https://bats-core.readthedocs.io/en/stable/)

## Troubleshooting

If you encounter any issues, please report them on the issue tracker at:
[fzf-help issues](https://github.com/BartSte/fzf-help/issues).

Please note that `fzf-help` is tested on Linux only.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING](./CONTRIBUTING.md) for
more information.

## License

Distributed under the [MIT License](./LICENCE).
