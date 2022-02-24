#!/bin/bash

unset _MAKE
_MAKE=$(which make)

if ${_MAKE} --version | grep -q GNU; then
    unset _MAKE
    _MAKE=$(which bmake)
fi

if [ -z "${_MAKE}" ]; then
    echo "Could not locate 'make'."
    exit 1
else
    export MAKE=${_MAKE}
    unset _MAKE
fi

run_make() {
    run ${MAKE} -C ${BATS_TEST_DIRNAME} "${@}"
}

source "$(dirname "${BASH_SOURCE[0]}")/bats-support/load.bash"
source "$(dirname "${BASH_SOURCE[0]}")/bats-assert/load.bash"
