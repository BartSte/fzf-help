#!/usr/bin/env bats
# vim: ft=bash
load test_helper/bats-assert/load
load test_helper/bats-support/load

setup() {
    selector_dir="$BATS_TEST_TMPDIR/selector"
    mkdir "$selector_dir"
    printf '%s\n' '#!/usr/bin/env bash' 'exit "$FZF_HELP_TEST_STATUS"' > "$selector_dir/fzf-select-option"
    chmod +x "$selector_dir/fzf-select-option"
}

@test "The Bash widget keeps its buffer after a failed or cancelled selection" {
    local expected

    for expected in 1 130; do
        run env FZF_HELP_TEST_STATUS="$expected" bash -c '
            source "$1"
            _fzf_help_directory="$2"
            READLINE_LINE="git status"
            READLINE_POINT=${#READLINE_LINE}
            fzf-help-widget
            selector_status=$?
            printf "status=%s\nline=%s\npoint=%s\n" "$selector_status" "$READLINE_LINE" "$READLINE_POINT"
            exit "$selector_status"
        ' bash "$BATS_TEST_DIRNAME/../src/fzf-help.bash" "$selector_dir"

        [ "$status" -eq "$expected" ]
        assert_output $'status='"$expected"$'\nline=git status\npoint=10'
    done
}

@test "The Zsh widget keeps its buffer after a failed or cancelled selection" {
    local expected

    for expected in 1 130; do
        run env FZF_HELP_TEST_STATUS="$expected" zsh -fc '
            zle() { return 0; }
            source "$1"
            _fzf_help_directory="$2"
            BUFFER="git status"
            fzf-help-widget
            selector_status=$?
            print -r -- "status=$selector_status"
            print -r -- "buffer=$BUFFER"
            exit "$selector_status"
        ' zsh "$BATS_TEST_DIRNAME/../src/fzf-help.zsh" "$selector_dir"

        [ "$status" -eq "$expected" ]
        assert_output $'status='"$expected"$'\nbuffer=git status'
    done
}

@test "The Fish widget keeps its buffer after a failed or cancelled selection" {
    local expected fish_code
    fish_code='
        function commandline
            if test (count $argv) -eq 0
                printf "%s" "$FZF_HELP_TEST_BUFFER"
                return 0
            end

            if test "$argv[1]" = "-r"
                set -g FZF_HELP_TEST_BUFFER "$argv[3]"
            end

            return 0
        end

        source $argv[1]
        set _fzf_help_directory $argv[2]
        fzf-help-widget
        set selector_status $status
        printf "status=%s\nbuffer=%s\n" $selector_status "$FZF_HELP_TEST_BUFFER"
        exit $selector_status
    '

    for expected in 1 130; do
        run env FZF_HELP_TEST_STATUS="$expected" FZF_HELP_TEST_BUFFER="git status" fish -c "$fish_code" "$BATS_TEST_DIRNAME/../src/fzf-help.fish" "$selector_dir"

        [ "$status" -eq "$expected" ]
        assert_output $'status='"$expected"$'\nbuffer=git status'
    done
}
