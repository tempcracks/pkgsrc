# $NetBSD: buildlink3.mk,v 1.1.1.1 2005/01/20 18:04:58 adrianp Exp $

BUILDLINK_DEPTH:=	${BUILDLINK_DEPTH}+
LIBNET_BUILDLINK3_MK:=	${LIBNET_BUILDLINK3_MK}+

.if !empty(BUILDLINK_DEPTH:M+)
BUILDLINK_DEPENDS+=	libnet
.endif

BUILDLINK_PACKAGES:=	${BUILDLINK_PACKAGES:Nlibnet}
BUILDLINK_PACKAGES+=	libnet

.if !empty(LIBNET_BUILDLINK3_MK:M+)
BUILDLINK_DEPENDS.libnet+=	libnet>=1.1.2.1
BUILDLINK_PKGSRCDIR.libnet?=	../../devel/libnet11
.endif	# LIBNET_BUILDLINK3_MK

BUILDLINK_DEPTH:=     ${BUILDLINK_DEPTH:S/+$//}
