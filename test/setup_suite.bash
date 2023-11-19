#!/usr/bin/env bats
# vim: ft=bash

setup_suite() {
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    PATH="$DIR/../src:$PATH"
}

