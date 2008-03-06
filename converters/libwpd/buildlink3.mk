# $NetBSD: buildlink3.mk,v 1.12 2008/03/06 14:53:48 wiz Exp $

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH}+
LIBWPD_BUILDLINK3_MK:=	${LIBWPD_BUILDLINK3_MK}+

.if !empty(BUILDLINK_DEPTH:M+)
BUILDLINK_DEPENDS+=	libwpd
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Nlibwpd}
BUILDLINK_PACKAGES+=	libwpd
BUILDLINK_ORDER:=	${BUILDLINK_ORDER} ${BUILDLINK_DEPTH}libwpd

.if !empty(LIBWPD_BUILDLINK3_MK:M+)
BUILDLINK_API_DEPENDS.libwpd+=	libwpd>=0.8.1nb1
BUILDLINK_ABI_DEPENDS.libwpd?=	libwpd>=0.8.9nb4
BUILDLINK_PKGSRCDIR.libwpd?=	../../converters/libwpd
.endif	# LIBWPD_BUILDLINK3_MK

.include "../../devel/libgsf/buildlink3.mk"

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH:S/+$//}
