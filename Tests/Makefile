REPORT_FORMAT?=	junit
TESTS=	\
	test-uses \

test:
.for TEST in ${TESTS}
	bats --timing --formatter ${REPORT_FORMAT} ${TEST}
.endfor
