TESTS=	\
	test-broken \
	test-prog-depends \
	test-uses \

.if defined(CI) && !empty(CI)
REPORT_FORMAT?=	junit
.elif defined(TERM) && !empty(TERM)
REPORT_FORMAT?=	pretty
.else
REPORT_FORMAT?=	tap
.endif

REPORT_PREFIX?= TEST-
.if ${REPORT_FORMAT} == "junit"
REPORT_SUFFIX=	.xml >/dev/null
.else
REPORT_SUFFIX=	.log
.endif

REPORT_DIR:=	${.PARSEDIR}/build/test-results

test:
	mkdir -p ${REPORT_DIR}
.for TEST in ${TESTS}
	${.CURDIR:tA}/helpers/bats-core/bin/bats --timing --formatter ${REPORT_FORMAT} ${TEST} \
		| tee ${REPORT_DIR}/${REPORT_PREFIX}${TEST}${REPORT_SUFFIX}
.endfor
