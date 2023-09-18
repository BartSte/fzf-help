# Changelog - fzf-help

This document describes the changes that were made to the software for each
version. The changes are described concisely, to make it comprehensible for the
user. A change is always categorized based on the following types:

- Bug: a fault in the software is fixed.
- Feature: a functionality is added to the program.
- Improvement: a functionality in the software is improved.
- Task: a change is made to the repository that has no effect on the source
  code.

# 1.0.0

- short options (-h) are now supported
- the options are now selected based on their index in the opts list. This is
  faster and more reliable. Duplicate options are now expected as this is
  desired: when scrolling through the options, the preview window will show each
  line where an option is mentioned.
- changed the names of the commands and the environment variables to be more
  descriptive.

# 0.4

- supports both bash and zsh.

# 0.3

- Added the `--multi` option to fzf

# 0.2

- Added syntax highlighting for `bat-cli-options`.

# 0.1

- Added `$CLI_OPTIONS_CMD`.
- Bugfix: shebangs were not compatible with macos
- Bugfix: LBUFFER was used instead of BUFFER in `fzf-help.zsh`

# 0.0

- Added `cli-options`.
- Added `bat-cli-options`.
- Added `fzf-select-options`.
- Added "right-bottom-toggle" for the preview window.
