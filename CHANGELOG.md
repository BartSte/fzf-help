# Changelog - fzf-help

This document describes the changes that were made to the software for each
version. The changes are described concisely, to make it comprehensible for the
user. A change is always categorized based on the following types:

- Bug: a fault in the software is fixed.
- Feature: a functionality is added to the program.
- Improvement: a functionality in the software is improved.
- Task: a change is made to the repository that has no effect on the source
  code.

If a change is breaking, this is mentioned and a major version is released.

# 2.0.1

## Bug

- The default value of `FZF_HELP_SYNTAX` was set to `txt` instead of `help` to
  support older versions of `bat`.

# 2.0.0

## Features

- Added FZF_HELP_SYNTAX environment variable to configure the syntax highlighting
  of the fzf preview window.
- Added support for the fish shell.

## Improvements

- **Breaking**: Refactored the install and uninstall scripts. The install directory is now
  `/usr/share/fzf-help` for root installations and `$HOME/.local/share/fzf-help`
  for user installations, independent of the shell.

# 1.1.0

## Features

- Added user installation

# 1.0.1

## Bug

- Added --bash option to uninstall script

# 1.0.0

## Features

- short options (-h) are now supported

## Improvements

- the options are now selected based on their index in the opts list. This is
  faster and more reliable. Duplicate options are now expected as this is
  desired: when scrolling through the options, the preview window will show each
  line where an option is mentioned.
- changed the names of the commands and the environment variables to be more
  descriptive.
- `bat-cli-options` was renamed to `fzf-select-option-preview`.

# 0.4

## Features

- supports both bash and zsh.

# 0.3

## Features

- Added the `--multi` option to fzf

# 0.2

## Features

- Added syntax highlighting for `bat-cli-options`.

# 0.1

## Features

- Added `$CLI_OPTIONS_CMD`.

## Bug

- shebangs were not compatible with macos
- LBUFFER was used instead of BUFFER in `fzf-help.zsh`

# 0.0

## Features

- Added `cli-options`.
- Added `bat-cli-options`.
- Added `fzf-select-options`.
- Added "right-bottom-toggle" for the preview window.
