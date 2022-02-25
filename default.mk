# Included on all `make(1)' executions.
# Defines default variables and targets.

.if !defined(_INCLUDE_DEFAULT_MK)
_INCLUDE_DEFAULT_MK=	yes

CURL_COMMAND=		curl -sSfm1
EC2_METADATA_URI=	http://169.254.169.254/latest/meta-data

.for f in ${:!ls ${USESDIR}!:M*.mk:C/\.mk$//}
.if !target(make${f}check)
make${f}check:
.if ${_chk_uses:M${f}}
	@true
.else
	@false
.endif
.endif
.endfor


targets:
	@printf '${.ALLTARGETS:@.t.@${.t.}${.newline}@}'


.SHELL: name=bash path=/bin/bash hasErrCtl=true \
	check="set -e" ignore="set +e" \
	echo="set -v" quiet="set +v" filter="set +v" \
	echoFlag=v errFlag=e newline="'\n'"

.endif #!defined(_INCLUDE_DEFAULT_MK)
