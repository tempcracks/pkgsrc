# $NetBSD: buildlink3.mk,v 1.4 2011/11/01 06:01:04 sbd Exp $

BUILDLINK_TREE+=	scintilla

.if !defined(SCINTILLA_BUILDLINK3_MK)
SCINTILLA_BUILDLINK3_MK:=

BUILDLINK_DEPMETHOD.scintilla?=	build

BUILDLINK_API_DEPENDS.scintilla+=	scintilla>=2.23
BUILDLINK_ABI_DEPENDS.scintilla?=	scintilla>=2.25nb2
BUILDLINK_PKGSRCDIR.scintilla?=	../../devel/scintilla

#.include "../../x11/gtk2/buildlink3.mk"
.endif	# SCINTILLA_BUILDLINK3_MK

BUILDLINK_TREE+=	-scintilla
