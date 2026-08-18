#!/usr/bin/env bats
# vim: ft=bash
load test_helper/bats-assert/load
load test_helper/bats-support/load
load helpers.bash

setup() {
    file=$(static "mv-help.txt")
    export HELP_MESSAGE_CMD="cat \"$file\""
}

teardown() {
    unset HELP_MESSAGE_CMD
}

@test "Run with -h" {
    fzf-select-option -h
}

@test "Run with --help" {
    fzf-select-option --help
}

@test "Run empty" {
    run fzf-select-option <<< ""
}

@test "Run with mv command" {
    run fzf-select-option -d mv
    assert_output "$(cat_static fzf-select-option-mv.txt)"
}
    
@test "Run with mv command and FZF_HELP_OPTS" {
    unset FZF_HELP_OPTS
    export FZF_HELP_OPTS=$'--foo\n--bar'
    run fzf-select-option -d mv
    assert_output "$(cat_static fzf-select-option-mv-fzf_help_opts.txt)"
}

@test "Supports legacy space-separated fzf arguments" {
    export FZF_HELP_OPTS="--foo --bar"

    run fzf-select-option -d mv

    assert_success
    assert_output "$(cat_static fzf-select-option-mv-fzf_help_opts.txt)"
}

@test "Sources the Bash integration from a path with spaces" {
    local source_dir source_file
    source_dir="$BATS_TEST_TMPDIR/source directory"
    source_file="$source_dir/fzf-help.bash"
    mkdir "$source_dir"
    cp "$BATS_TEST_DIRNAME/../src/fzf-help.bash" "$source_file"

    run bash -c 'source "$1"; printf "%s\\n" "$_fzf_help_directory"' bash "$source_file"

    assert_success
    assert_output "$source_dir"
}

@test "Sources the Zsh integration from a path with spaces" {
    local source_dir source_file
    source_dir="$BATS_TEST_TMPDIR/source directory"
    source_file="$source_dir/fzf-help.zsh"
    mkdir "$source_dir"
    cp "$BATS_TEST_DIRNAME/../src/fzf-help.zsh" "$source_file"

    run zsh -fc 'source "$1"; print -r -- "$_fzf_help_directory"' zsh "$source_file"

    assert_success
    assert_output "$source_dir"
}

@test "Reject two command arguments" {
    run fzf-select-option mv cp

    assert_failure
    assert_output 'Only one command argument is allowed.'
}

@test "Passes an fzf argument with spaces as one argument" {
    local fzf_dir
    fzf_dir="$BATS_TEST_TMPDIR/fzf-bin"
    mkdir "$fzf_dir"
    printf '%s\n' '#!/usr/bin/env bash' 'printf "<%s>\\n" "$@"' > "$fzf_dir/fzf"
    chmod +x "$fzf_dir/fzf"
    export FZF_HELP_OPTS=$'--prompt=Select an option\n--height\n80%'

    run env PATH="$fzf_dir:$PATH" FZF_HELP_OPTS="$FZF_HELP_OPTS" fzf-select-option mv

    assert_success
    assert_output --partial '<--prompt=Select an option>'
}

@test "Run with a help message that has no options" {
    export HELP_MESSAGE_CMD="printf 'No options\n'"

    run fzf-select-option -d example

    assert_success
    assert_output --partial 'echo "No help page or options found for example"'
}
