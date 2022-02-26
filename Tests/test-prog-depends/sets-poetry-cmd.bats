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

@test 'fails when poetry not present' {
    run_make -f uses-python.mk PATH=${MOCK_PATH} targets
    assert_failure
    assert_output --partial "Cannot determine location of 'poetry'."
}

@test 'fail when poetry present and not executable' {
    touch ${MOCK_PATH//*:/}/poetry
    run_make -f uses-python.mk PATH=${MOCK_PATH} targets
    assert_failure
    assert_output --partial "Cannot determine location of 'poetry'."
}

@test 'pass when poetry present' {
    touch ${MOCK_PATH//*:/}/poetry
    chmod u+x ${MOCK_PATH//*:/}/poetry
    run_make -f uses-python.mk PATH=${MOCK_PATH} targets
    assert_success
}

@test 'sets POETRY_CMD' {
    touch ${MOCK_PATH//*:/}/poetry
    chmod u+x ${MOCK_PATH//*:/}/poetry
    run_make -f uses-python.mk PATH=${MOCK_PATH} -V POETRY_CMD
    assert_output "${MOCK_PATH//*:/}/poetry"
}

@test 'respects custom POETRY_CMD' {
    touch ${MOCK_PATH//*:/}/poetry
    chmod u+x ${MOCK_PATH//*:/}/poetry
    run_make -f uses-python.mk POETRY_CMD=/foo/bar PATH=${MOCK_PATH} -V POETRY_CMD
    assert_output "/foo/bar"
}
