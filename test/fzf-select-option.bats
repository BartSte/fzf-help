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
    export FZF_HELP_OPTS="--foo --bar"
    run fzf-select-option -d mv
    assert_output "$(cat_static fzf-select-option-mv-fzf_help_opts.txt)"
}
