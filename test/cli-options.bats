#!/usr/bin/env bats
# vim: ft=bash

setup() {
    load helpers.bash
    global_setup
}

@test "Run with -h" {
    cli-options -h
}

@test "Run with --help" {
    cli-options --help
}

@test "Run empty stdin" {
    run cli-options <<< ""
    assert_output ""
}

@test "Assert 'mv --help' options" {
    run cli-options < "$(static mv-help.txt)"
    assert_output < "$(static mv-options.txt)"
}
