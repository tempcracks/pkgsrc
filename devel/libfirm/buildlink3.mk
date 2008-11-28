# $NetBSD: buildlink3.mk,v 1.1.1.1 2008/11/28 01:14:45 bjs Exp $

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH}+
LIBFIRM_BUILDLINK3_MK:=	${LIBFIRM_BUILDLINK3_MK}+

.if ${BUILDLINK_DEPTH} == "+"
BUILDLINK_DEPENDS+=	libfirm
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Nlibfirm}
BUILDLINK_PACKAGES+=	libfirm
BUILDLINK_ORDER:=	${BUILDLINK_ORDER} ${BUILDLINK_DEPTH}libfirm

.if ${LIBFIRM_BUILDLINK3_MK} == "+"
BUILDLINK_API_DEPENDS.libfirm+=	libfirm>=1.13.0
BUILDLINK_PKGSRCDIR.libfirm?=	../../devel/libfirm
.endif	# LIBFIRM_BUILDLINK3_MK

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH:S/+$//}
