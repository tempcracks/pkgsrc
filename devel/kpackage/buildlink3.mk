# $NetBSD: buildlink3.mk,v 1.5 2017/04/22 21:03:10 adam Exp $

BUILDLINK_TREE+=	kpackage

.if !defined(KPACKAGE_BUILDLINK3_MK)
KPACKAGE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.kpackage+=	kpackage>=5.19.0
BUILDLINK_ABI_DEPENDS.kpackage?=	kpackage>=5.25.0nb6
BUILDLINK_PKGSRCDIR.kpackage?=	../../devel/kpackage

.include "../../archivers/karchive/buildlink3.mk"
.include "../../devel/kconfig/buildlink3.mk"
.include "../../devel/kcoreaddons/buildlink3.mk"
.include "../../devel/ki18n/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# KPACKAGE_BUILDLINK3_MK

BUILDLINK_TREE+=	-kpackage
