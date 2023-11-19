#!/usr/bin/env bats
# vim: ft=bash

setup_suite() {
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PATH="$DIR/../src:$PATH"
    unset FZF_HELP_OPTS
    unset FZF_HELP_SYNTAX
    unset CLI_OPTIONS_CMD
    unset HELP_MESSAGE_CMD
}

