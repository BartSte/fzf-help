# vim: ft=bash

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

global_setup() {
    bats_load_library bats-assert
    bats_load_library bats-support
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PATH="$DIR/../src:$PATH"
}

setup() {
    global_setup
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
    export HELP_MESSAGE_CMD="echo \$cmd"
    run help-message ls
    assert_output "ls"
}
