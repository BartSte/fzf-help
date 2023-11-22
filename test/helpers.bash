#!/usr/bin/env bats
# vim: ft=bash

static() {
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    echo "$DIR/static/$1"
}

cat_static() {
    cat "$(static "$1")"
}
