#!/usr/bin/env bats
# vim: ft=bash
load test_helper/bats-assert/load
load test_helper/bats-support/load

setup() {
    bats_require_minimum_version 1.5.0
    source "$BATS_TEST_DIRNAME/../src/fzf-help-log"
    unset FZF_HELP_LOG_PATH
    unset FZF_HELP_LOG_LINES
}

@test "Log to /dev/null emits no output" {
    export FZF_HELP_LOG_PATH="/dev/null"

    run --separate-stderr fzf_help_log "message"

    assert_success
    assert_output ""
    [ -z "$stderr" ]
}

@test "Log to /dev/stdout emits only the message" {
    export FZF_HELP_LOG_PATH="/dev/stdout"

    run --separate-stderr fzf_help_log "message"

    assert_success
    assert_output "message"
    [ -z "$stderr" ]
}

@test "Log to /dev/stderr emits only the message" {
    export FZF_HELP_LOG_PATH="/dev/stderr"

    run --separate-stderr fzf_help_log "message"

    assert_success
    assert_output ""
    [ "$stderr" = "message" ]
}

@test "Log files keep the configured number of lines" {
    local log_file
    log_file="$BATS_TEST_TMPDIR/fzf-help.log"

    export FZF_HELP_LOG_PATH="$log_file"
    export FZF_HELP_LOG_LINES=2
    fzf_help_log "first"
    fzf_help_log "second"
    fzf_help_log "third"

    run cat "$log_file"

    assert_success
    assert_output $'second\nthird'
}
