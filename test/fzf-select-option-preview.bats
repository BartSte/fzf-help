#!/usr/bin/env bats
# vim: ft=bash
load test_helper/bats-assert/load
load test_helper/bats-support/load
load helpers.bash

@test "Run with -h" {
    fzf-select-option -h
}

@test "Run with --help" {
    fzf-select-option --help
}

@test "Run on mv" {
    local help opts index
    help="$(static mv-help.txt)"
    opts="$(cat_static mv-options.txt)"
    index=1
    run fzf-select-option-preview "$opts" $index < "$help"
    [ -n "$output" ]
}

@test "Run on mv command with -d" {
    local help opts index
    help="$(static mv-help.txt)"
    opts="$(cat_static mv-options.txt)"
    index=1

    run fzf-select-option-preview -d "$opts" $index < "$help"

    expected="$(cat_static fzf-select-option-preview-mv.txt)"
    assert_output "$expected"
}

@test "Run on mv, set env variables" {
    local help opts index
    export FZF_HELP_SYNTAX="man"
    export FZF_HELP_BAT_WARNING=false

    help="$(static mv-help.txt)"
    opts="$(cat_static mv-options.txt)"
    index=1

    run fzf-select-option-preview -d "$opts" $index < "$help"

    expected="$(cat_static fzf-select-option-preview-mv-vars.txt)"
    assert_output "$expected"
}
