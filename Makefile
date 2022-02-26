VERSION=	0.1.0
USES=		tar:xz

ARCHIVE_EXCLUDE+=	.git .github .hooks Tests .pre-commit-config.yaml .gitmodules

.include "build.mk"
