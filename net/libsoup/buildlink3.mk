# $NetBSD: buildlink3.mk,v 1.21 2016/05/03 11:37:39 prlw1 Exp $

BUILDLINK_TREE+=	libsoup

.if !defined(LIBSOUP_BUILDLINK3_MK)
LIBSOUP_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libsoup+=	libsoup>=2.50.0
BUILDLINK_ABI_DEPENDS.libsoup+=	libsoup>=2.54.1

BUILDLINK_PKGSRCDIR.libsoup?=	../../net/libsoup

pkgbase := libsoup
.include "../../mk/pkg-build-options.mk"

.include "../../databases/sqlite3/buildlink3.mk"
.include "../../devel/glib2/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"

.if !empty(PKG_BUILD_OPTIONS.libsoup:Mgssapi)
.include "../../mk/krb5.buildlink3.mk"
.endif

.endif	# LIBSOUP_BUILDLINK3_MK

BUILDLINK_TREE+=	-libsoup
