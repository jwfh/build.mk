#!/usr/bin/env bats

load ../helpers/setup

@test 'IGNORE fails with appropriate error' {
    run_make -f ignore.mk targets
    assert_failure
    assert_output --partial "IGNORE due to 'just to test'"
}

@test 'IGNORE fails runs when TRYBROKEN' {
    run_make -f ignore.mk -DTRYBROKEN targets
    assert_failure
}
