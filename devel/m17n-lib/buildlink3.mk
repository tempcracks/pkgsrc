# $NetBSD: buildlink3.mk,v 1.22 2018/01/07 13:04:07 rillig Exp $

BUILDLINK_TREE+=	m17n-lib

.if !defined(M17N_LIB_BUILDLINK3_MK)
M17N_LIB_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.m17n-lib+=	m17n-lib>=1.5.1
BUILDLINK_ABI_DEPENDS.m17n-lib+=	m17n-lib>=1.7.0nb5
BUILDLINK_PKGSRCDIR.m17n-lib?=		../../devel/m17n-lib

pkgbase := m17n-lib
.include "../../mk/pkg-build-options.mk"

.if !empty(PKG_BUILD_OPTIONS.m17n-lib:Manthy)
.include "../../inputmethod/anthy/buildlink3.mk"
.endif

.if !empty(PKG_BUILD_OPTIONS.m17n-lib:Mx11)
.include "../../fonts/fontconfig/buildlink3.mk"
.include "../../graphics/freetype2/buildlink3.mk"
.include "../../graphics/gd/buildlink3.mk"
.include "../../graphics/libotf/buildlink3.mk"
.include "../../x11/libICE/buildlink3.mk"
.include "../../x11/libSM/buildlink3.mk"
.include "../../x11/libX11/buildlink3.mk"
.include "../../x11/libXft/buildlink3.mk"
.include "../../x11/libXt/buildlink3.mk"
.endif

.if !empty(PKG_BUILD_OPTIONS.m17n-lib:Mlibthai)
.include "../../devel/libthai/buildlink3.mk"
.endif

.include "../../converters/fribidi/buildlink3.mk"
.include "../../converters/libiconv/buildlink3.mk"
.include "../../devel/gettext-lib/buildlink3.mk"
.include "../../misc/m17n-db/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.endif # M17N_LIB_BUILDLINK3_MK

BUILDLINK_TREE+=	-m17n-lib
