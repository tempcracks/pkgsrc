# $NetBSD: buildlink3.mk,v 1.8 2017/04/22 21:03:19 adam Exp $

BUILDLINK_TREE+=	kdelibs4support

.if !defined(KDELIBS4SUPPORT_BUILDLINK3_MK)
KDELIBS4SUPPORT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.kdelibs4support+=	kdelibs4support>=5.21.0
BUILDLINK_ABI_DEPENDS.kdelibs4support?=	kdelibs4support>=5.25.0nb7
BUILDLINK_PKGSRCDIR.kdelibs4support?=	../../x11/kdelibs4support

.include "../../misc/kemoticons/buildlink3.mk"
.include "../../devel/kitemmodels/buildlink3.mk"
.include "../../misc/kunitconversion/buildlink3.mk"
.include "../../devel/kparts/buildlink3.mk"
.include "../../x11/qt5-qtbase/buildlink3.mk"
.endif	# KDELIBS4SUPPORT_BUILDLINK3_MK

BUILDLINK_TREE+=	-kdelibs4support
