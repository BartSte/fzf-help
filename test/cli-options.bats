#!/usr/bin/env bats
# vim: ft=bash
load test_helper/bats-assert/load
load test_helper/bats-support/load
load helpers.bash

assert_cli_options() {
    local input="$1"
    local expected="$2"

    run cli-options <<<"$input"
    if [[ -n "$expected" ]]; then
        assert_success
    else
        assert_failure
    fi
    assert_output "$expected"
}

assert_cli_options_fixture() {
    local input_name="$1"
    local expected_name="$2"

    run cli-options <"$(static "cli-options/$input_name")"
    assert_success
    assert_output "$(cat_static "cli-options/$expected_name")"
}

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
    assert_output "$(cat_static mv-options.txt)"
}

@test "Finds a one-character long option" {
    run cli-options <<<'Use --x to enable the feature.'
    assert_success
    assert_output '1:--x'
}

@test "Finds every supported short-option character" {
    local supported_characters='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?.:#@~'
    local index
    local option

    for ((index = 0; index < ${#supported_characters}; index++)); do
        option="-${supported_characters:index:1}"
        assert_cli_options "$option" "1:$option"
    done
}

@test "Finds supported long names and removes argument syntax" {
    local -a cases=(
        '--x' '1:--x'
        '--3way' '1:--3way'
        '--dry-run' '1:--dry-run'
        '--foo_bar' '1:--foo_bar'
        '--color=WHEN' '1:--color'
        '--backup[=CONTROL]' '1:--backup'
        '--file FILE' '1:--file'
        'Use --help.' '1:--help'
    )
    local index

    for ((index = 0; index < ${#cases[@]}; index += 2)); do
        assert_cli_options "${cases[index]}" "${cases[index + 1]}"
    done
}

@test "Removes supported short-option argument syntax" {
    local -a cases=(
        '-# [N]' '1:-#'
        '-o=FILE' '1:-o'
        '-F:' '1:-F'
    )
    local index

    for ((index = 0; index < ${#cases[@]}; index += 2)); do
        assert_cli_options "${cases[index]}" "${cases[index + 1]}"
    done
}

@test "Finds both supported hyphen forms without mixing them" {
    assert_cli_options '-h --help ‐h ‐‐help' $'1:-h\n1:--help\n1:‐h\n1:‐‐help'
    assert_cli_options '-‐help ‐-help' ''
}

@test "Finds options after supported left boundaries" {
    local -a prefixes=('' ' ' '[' '(' '{' '<' "'" '"' '`' ':' '/')
    local prefix

    for prefix in "${prefixes[@]}"; do
        assert_cli_options "${prefix}--help" '1:--help'
    done
}

@test "Rejects options after word and hyphen characters" {
    local -a cases=(
        'word--option'
        '0--option'
        '_--option'
        '---help'
        '‐--help'
        'word-h'
        '_‐h'
    )
    local input

    for input in "${cases[@]}"; do
        assert_cli_options "$input" ''
    done
}

@test "Finds options before supported right boundaries" {
    local -a suffixes=(
        '' ' value' $'\tvalue'
        '[' ']' '(' ')' '{' '}' '<' '>' '=' "'" '"' '`'
        ',' ';' ':' '.' '!' '?'
    )
    local suffix

    for suffix in "${suffixes[@]}"; do
        assert_cli_options "--help${suffix}" '1:--help'
    done

    local -a terminal_followers=('' ' ' '-' '‐' ']' ')' '}' '>' "'" '"' '`')
    local punctuation
    local follower

    for punctuation in ',' ';' ':' '.' '!' '?'; do
        for follower in "${terminal_followers[@]}"; do
            assert_cli_options "--help${punctuation}${follower}" '1:--help'
        done
    done
}

@test "Finds slash-separated and pipe-separated aliases" {
    assert_cli_options '-h, --help' $'1:-h\n1:--help'
    assert_cli_options '-h/--help' $'1:-h\n1:--help'
    assert_cli_options '-h|--help' $'1:-h\n1:--help'
    assert_cli_options '[-h]' '1:-h'
    assert_cli_options '`--help`' '1:--help'
}

@test "Rejects partial names before unsupported right boundaries" {
    local -a cases=(
        '--help.value'
        '--help+value'
        '--help/value'
        '--help|value'
        '--help,word'
        '-aX'
        '-a_'
        '-a/value'
    )
    local input

    for input in "${cases[@]}"; do
        assert_cli_options "$input" ''
    done
}

@test "Rejects unsupported option forms without partial matches" {
    local -a cases=(
        '--' '-'
        '-abc' '-46Aa' '-OO'
        '-10'
        '-j8' '-A2' '-DNAME' '-I/usr/include'
        '-verbose' '-name' '-classpath' '-XX:+UseG1GC'
        '+f' '++foo' '/help'
        '—help' '−h'
        '--log.level' '--name+value'
        '--naïve' '-é'
        $'--na\033[31mme'
        $'--na\\\nme'
    )
    local input

    for input in "${cases[@]}"; do
        assert_cli_options "$input" ''
    done
}

@test "Keeps duplicate matches and their line numbers" {
    assert_cli_options $'Use --help here.\nUse --help again.' $'1:--help\n2:--help'
}

@test "Extracts options from fixed supported-format fixtures" {
    assert_cli_options_fixture 'gnu-arguments.txt' 'gnu-arguments-options.txt'
    assert_cli_options_fixture 'python-zsh-short-names.txt' 'python-zsh-short-names-options.txt'
    assert_cli_options_fixture 'ripgrep-aliases.txt' 'ripgrep-aliases-options.txt'
    assert_cli_options_fixture 'punctuation-short-names.txt' 'punctuation-short-names-options.txt'
}

@test "Rejects ambiguous forms in fixed help-message fixtures" {
    run cli-options <"$(static 'cli-options/bash-ls-groups.txt')"
    assert_failure
    assert_output ''

    run cli-options <"$(static 'cli-options/tar-ripgrep-attached-values.txt')"
    assert_failure
    assert_output ''

    run cli-options <"$(static 'cli-options/find-java-ffmpeg-single-hyphen.txt')"
    assert_failure
    assert_output ''
}

@test "Set CLI_OPTIONS_CMD" {
    export CLI_OPTIONS_CMD="echo 'foo'"
    run cli-options <"$(static mv-help.txt)"
    assert_output "foo"
}

@test "Assert edge cases" {
    run cli-options <"$(static edge-cases.txt)"
    assert_output "$(cat_static edge-cases-options.txt)"
}
