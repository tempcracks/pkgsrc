# $NetBSD: buildlink3.mk,v 1.4 2007/06/08 12:25:01 wiz Exp $

BUILDLINK_DEPTH:=		${BUILDLINK_DEPTH}+
APR_UTIL_BUILDLINK3_MK:=	${APR_UTIL_BUILDLINK3_MK}+

.if !empty(BUILDLINK_DEPTH:M+)
BUILDLINK_DEPENDS+=	apr-util
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Napr-util}
BUILDLINK_PACKAGES+=	apr-util
BUILDLINK_ORDER:=	${BUILDLINK_ORDER} ${BUILDLINK_DEPTH}apr-util

.if !empty(APR_UTIL_BUILDLINK3_MK:M+)
BUILDLINK_API_DEPENDS.apr-util+=	apr-util>=1.2.8
BUILDLINK_ABI_DEPENDS.apr-util?=	apr-util>=1.2.8nb1
BUILDLINK_PKGSRCDIR.apr-util?=	../../devel/apr-util
.endif	# APR_UTIL_BUILDLINK3_MK

BUILDLINK_FILES.apr-util+=	bin/apu-1-config
BUILDLINK_FILES.apr-util+=	lib/aprutil.exp

.include "../../mk/bsd.fast.prefs.mk"

pkgbase := apr-util
.include "../../mk/pkg-build-options.mk"

.if !empty(PKG_BUILD_OPTIONS.apr-util:Mdb4)
.  include "../../databases/db4/buildlink3.mk"
.endif

.if !empty(PKG_BUILD_OPTIONS.apr-util:Mldap)
.  include "../../databases/openldap-client/buildlink3.mk"
.endif

.include "../../converters/libiconv/buildlink3.mk"
.include "../../devel/apr/buildlink3.mk"
.include "../../textproc/expat/buildlink3.mk"
.include "../../mk/dlopen.buildlink3.mk"

BUILDLINK_DEPTH:=		${BUILDLINK_DEPTH:S/+$//}
