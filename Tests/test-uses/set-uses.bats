#!/usr/bin/env bats

load ../helpers/setup

@test "sets _INCLUDE_USES for present USES" {
    run_make -V _INCLUDE_USES_PYTHON_MK
    assert_output "yes"
    run_make -V _INCLUDE_USES_CMAKE_MK
    assert_output "yes"
}

@test "does not set _INCLUDE_USES for absent USES" {
    run_make -V _INCLUDE_USES_JAVA_MK
    refute_output "yes"
}
