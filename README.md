# Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [Improvements](#improvements)

# Introduction
`fzf-help` is an `fzf` extension that allows you to select one of the command
line options of a given command. The options are retrieved from the command its
`--help` documentation, which is displayed in a preview window.

## TODO: add demo gif

# Installation
Ensure that you have the following tools installed:
- [fzf](www.github.com/junegunn/fzf)
- [bat](www.github.com/sharkdp/bat)
- [ag](www.github.com/ggreer/the_silver_searcher)

Next, run the following command to install fzf-help in the zsh plugin directory
at `/usr/share/zsh/plugins`.
```bash
local tmp_dir=$(mktemp -d);
git clone https://github.com/BartSte/fzf-help.git $tmp_dir;
sudo $tmp_dir/install;
rm -rf $tmp_dir;
```

After installation, add the following line to your `.zshrc` file:
```bash
source /usr/share/zsh/plugins/fzf-help/fzf-help.zsh

zle -N fzf-help-widget
bindkey -M vicmd "^A" fzf-help-widget
bindkey -M viins "^A" fzf-help-widget
```
which will bind the `fzf-help-widget` to the `ctrl-a`, which you should trigger
after typing the command you want to get help for.

# Configuration
The following environment variables can be set to configure the behaviour of
`fzf-help`:
- `FZF_HELP_OPTS`: options to pass to `fzf` when selecting the command to get
  help for. Defaults to:
  ```bash
  FZF_HELP_OPTS="--preview-window=right,75%,nowrap --height 80% "
  FZF_HELP_OPTS+="--bind ctrl-a:change-preview-window(down,75%,nowrap|right,75%,nowrap)"
  ```
- `CLI_OPTIONS_REGEX`: regex to match the command line options in the `--help`
    documentation. Check the `cli_options` command for the default value.

# Usage
As the demo shows, you can use `fzf-help` by typing `ctrl-a` after typing the
command you want to get help for. This will open `fzf` with a list of options
and the `--help` documentation in the preview window. You can press `ctrl-a`
again to toggle the preview window to the bottom or the right of the widget.

# Troubleshooting
If you encounter any issues, please report them on the issue tracker at:
[fzf-help issues](https://github.com/BartSte/fzf-help/issues)

## Contributing
Contributions are welcome! Please see [CONTRIBUTING](./CONTRIBUTING.md) for
more information.

# License
Distributed under the [MIT License](./LICENCE).

# Improvements
- [ ] The `CLI_OPTIONS_REGEX` could be improved as occasionally it will miss
some options.
