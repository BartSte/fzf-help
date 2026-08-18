#!/usr/bin/env bats
# vim: ft=bash
load test_helper/bats-assert/load
load test_helper/bats-support/load

@test "Creates unique temporary files" {
    local first second

    run make-temp fzf-help-message
    assert_success
    first="$output"
    [ -f "$first" ]

    run make-temp fzf-help-message
    assert_success
    second="$output"
    [ -f "$second" ]
    [ "$first" != "$second" ]

    rm -f "$first" "$second"
}
