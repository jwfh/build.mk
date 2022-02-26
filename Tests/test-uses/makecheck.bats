#!/usr/bin/env bats

load ../helpers/setup

@test 'makecheck passes when included USES check called' {
    run_make -f uses-python-cmake.mk makepythoncheck
    assert_success
}

@test 'makecheck fails when un-included USES check called' {
    run_make -f uses-python-cmake.mk makejavacheck
    assert_failure
}

@test 'makecheck fails when invalid check called' {
    run_make -f uses-python-cmake.mk makeinvalidcheckcheck
    assert_failure
    assert_output --partial "don't know how to make makeinvalidcheckcheck"
}
