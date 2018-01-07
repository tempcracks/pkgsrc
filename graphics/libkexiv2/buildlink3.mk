# $NetBSD: buildlink3.mk,v 1.20 2018/01/07 13:04:15 rillig Exp $

BUILDLINK_TREE+=	libkexiv2

.if !defined(LIBKEXIV2_BUILDLINK3_MK)
LIBKEXIV2_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libkexiv2+=	libkexiv2>=4.8.0
BUILDLINK_PKGSRCDIR.libkexiv2?=		../../graphics/libkexiv2

.endif	# LIBKEXIV2_BUILDLINK3_MK

BUILDLINK_TREE+=	-libkexiv2
