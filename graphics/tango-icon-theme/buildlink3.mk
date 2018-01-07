# $NetBSD: buildlink3.mk,v 1.2 2018/01/07 13:04:16 rillig Exp $

BUILDLINK_TREE+=	tango-icon-theme

.if !defined(TANGO_ICON_THEME_BUILDLINK3_MK)
TANGO_ICON_THEME_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.tango-icon-theme+=	tango-icon-theme>=0.8.90
BUILDLINK_PKGSRCDIR.tango-icon-theme?=		../../graphics/tango-icon-theme
.endif # TANGO_ICON_THEME_BUILDLINK3_MK

BUILDLINK_TREE+=	-tango-icon-theme
