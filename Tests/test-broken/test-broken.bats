#!/usr/bin/env bats

load ../helpers/setup

@test 'BROKEN fails with appropriate error' {
    run_make -f broken.mk targets
    assert_failure
    assert_output --partial "BROKEN due to 'just to test'"
}

@test 'BROKEN runs when TRYBROKEN' {
    run_make -f broken.mk -DTRYBROKEN targets
    assert_success
    assert_output --partial "warning: BROKEN due to 'just to test'."
    assert_output --partial "TRYBROKEN is defined"
}
