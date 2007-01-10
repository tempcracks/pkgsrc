# $NetBSD: buildlink3.mk,v 1.10 2007/01/10 15:45:26 joerg Exp $

BUILDLINK_DEPTH:=		${BUILDLINK_DEPTH}+
LIBKEXIF_BUILDLINK3_MK:=	${LIBKEXIF_BUILDLINK3_MK}+

.if !empty(BUILDLINK_DEPTH:M+)
BUILDLINK_DEPENDS+=	libkexif
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Nlibkexif}
BUILDLINK_PACKAGES+=	libkexif
BUILDLINK_ORDER:=	${BUILDLINK_ORDER} ${BUILDLINK_DEPTH}libkexif

.if !empty(LIBKEXIF_BUILDLINK3_MK:M+)
BUILDLINK_API_DEPENDS.libkexif+=	libkexif>=0.2.5
BUILDLINK_PKGSRCDIR.libkexif?=	../../graphics/libkexif
.endif	# LIBKEXIF_BUILDLINK3_MK

.include "../../graphics/libexif/buildlink3.mk"
.include "../../x11/kdelibs3/buildlink3.mk"
.include "../../x11/libSM/buildlink3.mk"
.include "../../x11/libXext/buildlink3.mk"

BUILDLINK_DEPTH:=		${BUILDLINK_DEPTH:S/+$//}
