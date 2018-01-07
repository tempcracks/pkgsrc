# $NetBSD: buildlink3.mk,v 1.7 2018/01/07 13:04:06 rillig Exp $

BUILDLINK_TREE+=	libmemmgr

.if !defined(LIBMEMMGR_BUILDLINK3_MK)
LIBMEMMGR_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libmemmgr+=	libmemmgr>=1.04
BUILDLINK_PKGSRCDIR.libmemmgr?=		../../devel/libmemmgr
BUILDLINK_DEPMETHOD.libmemmgr?=		build

.include "../../devel/libetm/buildlink3.mk"
.endif # LIBMEMMGR_BUILDLINK3_MK

BUILDLINK_TREE+=	-libmemmgr
