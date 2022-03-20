VERSION=	0.2.1
USES=		tar:xz

ARCHIVE_EXCLUDE+=	.git .github .hooks Tests .pre-commit-config.yaml .gitmodules

.include "build.mk"
