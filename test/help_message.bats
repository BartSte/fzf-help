setup() {
    #TODO: do not hardcode BATS_LIB_PATH
    # Maybe it is easier add bats as a submodule and use it directly:
    # git submodule add https://github.com/bats-core/bats-core.git test/bats
    # git submodule add https://github.com/bats-core/bats-support.git test/test_helper/bats-support
    # git submodule add https://github.com/bats-core/bats-assert.git test/test_helper/bats-assert

    BATS_LIB_PATH=/usr/lib:/usr/lib/bats

    bats_load_library bats-assert
    bats_load_library bats-support

    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$DIR/../src:$PATH"
}

@test "Empty help message"
    help-message
    assert_output ""
}
