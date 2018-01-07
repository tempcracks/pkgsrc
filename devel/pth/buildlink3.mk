# $NetBSD: buildlink3.mk,v 1.12 2018/01/07 13:04:10 rillig Exp $

BUILDLINK_TREE+=	pth

.if !defined(PTH_BUILDLINK3_MK)
PTH_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.pth+=	pth>=2.0.0
BUILDLINK_ABI_DEPENDS.pth+=	pth>=2.0.0nb2
BUILDLINK_PKGSRCDIR.pth?=	../../devel/pth

LIBS.SunOS+=			-lresolv
.endif # PTH_BUILDLINK3_MK

BUILDLINK_TREE+=	-pth
