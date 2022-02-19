# Included on all `make(1)' executions.
# Defines default variables and targets.

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
