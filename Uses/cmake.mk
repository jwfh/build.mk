.if !defined(_INCLUDE_USES_CMAKE_MK)
_INCLUDE_USES_CMAKE_MK=	yes

PROG_DEPENDS+= cmake

.if "${cmake_ARGS:Mninja}"
PROG_DEPENDS+=	ninja
.endif

.endif #!defined(_INCLUDE_USES_CMAKE_MK)
