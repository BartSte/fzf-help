#!/usr/bin/env bats
# vim: ft=bash
bats_load_library bats-assert
bats_load_library bats-support
load helpers.bash

@test "Run with -h" {
    cli-options -h
}

@test "Run with --help" {
    cli-options --help
}

@test "Run empty stdin" {
    run cli-options <<<""
    assert_output ""
}

@test "Assert 'mv --help' options" {
    run cli-options <"$(static mv-help.txt)"
    assert_output <"$(static mv-options.txt)"
}

@test "Set CLI_OPTIONS_CMD" {
    export CLI_OPTIONS_CMD="echo 'foo'"
    run cli-options <"$(static mv-help.txt)"
    assert_output "foo"
}
