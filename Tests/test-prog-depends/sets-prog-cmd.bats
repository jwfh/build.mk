#!/usr/bin/env bats

load ../helpers/setup

setup() {
    unset MOCK_PATH
    export MOCK_PATH="/bin:/usr/bin:$(mktemp -d /tmp/test-prog-depends.XXXXXX):$(mktemp -d /tmp/test-prog-depends.XXXXXX)"
}

teardown() {
    for d in $(tr ':' '\n' <<<"${MOCK_PATH}" | grep -e '^/tmp/test-prog-depends.*'); do
        rm -fr ${d}
    done
}

@test 'fails when program not present' {
    run_make -f uses-build-program.mk PATH=${MOCK_PATH} targets
    assert_failure
    assert_output --partial "Cannot determine location of 'my-build-program'."
}

@test 'fail when program present and not executable' {
    touch ${MOCK_PATH//*:/}/my-build-program
    run_make -f uses-build-program.mk PATH=${MOCK_PATH} targets
    assert_failure
    assert_output --partial "Cannot determine location of 'my-build-program'."
}

@test 'pass when program present' {
    touch ${MOCK_PATH//*:/}/my-build-program
    chmod u+x ${MOCK_PATH//*:/}/my-build-program
    run_make -f uses-build-program.mk PATH=${MOCK_PATH} targets
    assert_success
}

@test 'sets program command' {
    touch ${MOCK_PATH//*:/}/my-build-program
    chmod u+x ${MOCK_PATH//*:/}/my-build-program
    run_make -f uses-build-program.mk PATH=${MOCK_PATH} -V MYBUILDPROGRAM_CMD
    assert_output "${MOCK_PATH//*:/}/my-build-program"
}

@test 'respects custom MY-BUILD-PROGRAM_CMD' {
    touch ${MOCK_PATH//*:/}/my-build-program
    chmod u+x ${MOCK_PATH//*:/}/my-build-program
    run_make -f uses-build-program.mk MYBUILDPROGRAM_CMD=/foo/bar PATH=${MOCK_PATH} -V MYBUILDPROGRAM_CMD
    assert_output "/foo/bar"
}
