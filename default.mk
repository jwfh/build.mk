# Included on all `make(1)' executions.
# Defines default variables and targets.

.if !defined(_INCLUDE_DEFAULT_MK)
_INCLUDE_DEFAULT_MK=	yes

PROG_DEPENDS+=	mkdir
PROG_DEPENDS+=	rm

CURL_CMD=		curl -sSfm1
EC2_METADATA_URI=	http://169.254.169.254/latest/meta-data

init:
	${MKDIR_CMD} -p ${WORKDIR:Q}

build: init ${BUILD_TARGETS}
test: ${TEST_TARGETS}
deploy: ${DEPLOY_TARGETS}
all: build

ARCHIVE_EXCLUDE+=	work
ARCHIVE_INCLUDE?=	.

.for udir in ${OVERLAYS:C,$,/Mk/Uses,} ${USESDIR}
.for f in ${:!ls ${udir}!:M*.mk:C/\.mk$//}
_f:=${f:C/[^a-zA-Z0-9]//g}
.if !target(make${f}check)
make${f}check:
.if ${_chk_uses:M${f}}
	@true
.else
	@false
.endif
.endif
.endfor
.endfor

clean:
	${RM_CMD} -fr ${WORKDIR:Q}

targets:
	@printf '${.ALLTARGETS:@.t.@${.t.}${.newline}@}'

.SHELL: name=bash path=/bin/bash hasErrCtl=true \
	check="set -e" ignore="set +e" \
	echo="set -v" quiet="set +v" filter="set +v" \
	echoFlag=v errFlag=e newline="'\n'"

.endif #!defined(_INCLUDE_DEFAULT_MK)
