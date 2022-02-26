TESTS=	\
	test-broken \
	test-uses \

.if defined(TERM) && !empty(TERM)
REPORT_FORMAT?=	pretty
.else
REPORT_FORMAT?=	tap
.endif

test:
.for TEST in ${TESTS}
	${.CURDIR:tA}/helpers/bats-core/bin/bats --timing --formatter ${REPORT_FORMAT} ${TEST}
.endfor
