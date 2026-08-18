#!/usr/bin/env bats
# vim: ft=bash
load test_helper/bats-assert/load
load test_helper/bats-support/load
load helpers.bash

get_temp() {
    local tmpdir
    tmpdir=$(dirname "$(mktemp tmp.XXXXXXXXXX -ut)")
    echo "$tmpdir/fzf-help-message"
}

rm_temp() {
    local file
    file=$(get_temp)
    if [[ -f $file ]]; then
        rm "$file"
    fi
}

setup() {
    rm_temp
}

@test "Run without command" {
    help-message
}

@test "Run with command" {
    help-message ls
}

@test "Empty help message" {
    run help-message
    assert_output ""
}

@test "Non empty help message" {
    run help-message ls
    assert_output "$(ls --help)"
}

@test "Cached help message" {
    help-message ls
    run help-message
    assert_output "$(ls --help)"
}

@test "Set HELP_MESSAGE_CMD" {
    export HELP_MESSAGE_CMD='printf "custom:%s\\n" "$cmd"'
    run help-message ls
    assert_output "custom:ls"
}

@test "Runs the default command with --help" {
    local command_dir
    command_dir="$BATS_TEST_TMPDIR/commands"
    mkdir "$command_dir"
    printf '%s\n' '#!/usr/bin/env bash' 'printf "argument=%s\\n" "$1"' > "$command_dir/example-command"
    chmod +x "$command_dir/example-command"

    run env PATH="$command_dir:$PATH" help-message example-command

    assert_success
    assert_output "argument=--help"
}

@test "Runs executable paths and subcommands" {
    local command command_dir
    command_dir="$BATS_TEST_TMPDIR/commands"
    command="$command_dir/example-command"
    mkdir "$command_dir"
    printf '%s\n' '#!/usr/bin/env bash' 'printf "arguments=%s\\n" "$*"' > "$command"
    chmod +x "$command"

    run help-message "$command"

    assert_success
    assert_output "arguments=--help"

    run env PATH="$command_dir:$PATH" help-message example-command status

    assert_success
    assert_output "arguments=status --help"

    run env PATH="$command_dir:$PATH" help-message "example-command status"

    assert_success
    assert_output "arguments=status --help"
}

@test "Does not run shell syntax from the command argument" {
    local marker
    marker="$BATS_TEST_TMPDIR/command-ran"

    run help-message "example; touch $marker"

    assert_failure
    assert_output "The command contains unsupported characters."
    [ ! -e "$marker" ]
}
