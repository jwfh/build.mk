REPORT_FORMAT?=	junit
TESTS=	\
	test-broken \
	test-uses \

test:
.for TEST in ${TESTS}
	${.CURDIR:tA}/helpers/bats-core/bin/bats --timing --formatter ${REPORT_FORMAT} ${TEST}
.endfor
