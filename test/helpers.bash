#!/usr/bin/env bats
# vim: ft=bash

global_setup() {
    bats_load_library bats-assert
    bats_load_library bats-support
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PATH="$DIR/../src:$PATH"
}

static() {
    echo "$DIR/static/$1"
}
