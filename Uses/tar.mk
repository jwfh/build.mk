.if !defined(_INCLUDE_USES_TAR_MK)
_INCLUDE_USES_TAR_MK=	yes

tar_VALID_ARGS=	xz

PROG_DEPENDS+=	tar
_TAR_EXTENSION=	.tgz
.if "${tar_ARGS:Mxz}"
PROG_DEPENDS+=	xz
_TAR_EXTENSION=	.txz
.endif

BUILD_TARGETS+=	tar
tar: init
	${TAR_CMD} -cvf ${WORKDIR:Q}/${NAME}${_TAR_EXTENSION} ${ARCHIVE_EXCLUDE:@.f.@--exclude ${.f.:Q}@} ${ARCHIVE_INCLUDE:Q}

.endif #!defined(_INCLUDE_USES_TAR_MK)
