#!/usr/bin/env bash

# Shortcut to the bats executable at `./test/bats/bin/bats`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
"$DIR"/test/bats/bin/bats $@
