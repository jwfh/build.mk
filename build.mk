# Ensure .CURDIR contains an absolute path without a trailing slash.  Failed
# builds can occur when .CURDIR is a symbolic link, or with something like
# make -C /repos/${REPO_NAME}/.
.CURDIR:=	${.CURDIR:tA}
REPO_ROOT!=	git rev-parse --show-toplevel

USES?=
USESDIR?=	${.PARSEDIR}/Uses
SCRIPTSDIR?=	${.PARSEDIR}/Scripts
TEMPLATESDIR?=	${.PARSEDIR}/Templates
LOCALBASE?=	/usr/local

.if exists(${REPO_ROOT}/settings.mk)
.include "${REPO_ROOT}/settings.mk"
.endif

# Exit or warning on broken packages
BROKEN?=
IGNORE?=
.if ${.TARGETS:Nmake*check} != "" && (!empty(BROKEN) && !defined(TRYBROKEN) || !empty(IGNORE))
.error ${!empty(BROKEN):?BROKEN due to '${BROKEN}':IGNORE due to '${IGNORE}'}
.elif !empty(BROKEN) && defined(TRYBROKEN)
.warning BROKEN due to '${BROKEN}'. Attempting to build anyway because TRYBROKEN is defined.
.endif

# Loading features
_chk_uses=
.for f in ${USES}
_f:=		${f:C/\:.*//}
_chk_uses:=	${_chk_uses} ${_f}
.if !defined(${_f}_ARGS)
${_f}_ARGS:=	${f:C/^[^\:]*(\:|\$)//:S/,/ /g}
.endif
.undef _usefound
.for udir in ${OVERLAYS:C,$,/Mk/Uses,} ${USESDIR}
_usefile=	${udir}/${_f}.mk
.if exists(${_usefile}) && !defined(_usefound)
_usefound=
.include "${_usefile}"
.endif
.endfor
.if !defined(_usefound)
.error Unknown USES=${_f}
.endif
.if (!defined(${_f}_VALID_ARGS) || empty(${_f}_VALID_ARGS)) && !empty(${_f}_ARGS)
.error Incorrect 'USES+= ${_f}:${${_f}_ARGS}' ${_f} takes no arguments
.else
.for arg in ${${_f}_ARGS}
.if empty(${_f}_VALID_ARGS:M${arg})
.error Incorrect 'USES+= ${_f}:${${_f}_ARGS}' usage: argument [${arg}] is not recognized
.endif
.endfor
.endif
.endfor

.include "default.mk"
