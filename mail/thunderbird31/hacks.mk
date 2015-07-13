# $NetBSD: hacks.mk,v 1.1 2015/07/13 17:49:26 ryoon Exp $

# workround for link of thunderbird-bin etc.
LDFLAGS+=	-Wl,-R${PREFIX}/lib/thunderbird

.if ${OPSYS} == "SunOS"
# workaround for strip problems with libxul.so
# https://www.illumos.org/issues/4383
INSTALL_UNSTRIPPED=yes
.endif
.include "../../devel/xulrunner17/hacks.mk"
