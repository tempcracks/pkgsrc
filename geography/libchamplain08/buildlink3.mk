# $NetBSD: buildlink3.mk,v 1.39 2017/09/18 09:53:00 maya Exp $

BUILDLINK_TREE+=	libchamplain08

.if !defined(LIBCHAMPLAIN08_BUILDLINK3_MK)
LIBCHAMPLAIN08_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libchamplain08+=	libchamplain08>=0.8.3
BUILDLINK_ABI_DEPENDS.libchamplain08+=	libchamplain08>=0.8.3nb38
BUILDLINK_PKGSRCDIR.libchamplain08?=	../../geography/libchamplain08

.include "../../devel/glib2/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
.include "../../graphics/clutter-gtk0.10/buildlink3.mk"
.include "../../databases/sqlite3/buildlink3.mk"
.include "../../net/libsoup/buildlink3.mk"

#.include "../../geography/memphis/buildlink3.mk"
.endif	# LIBCHAMPLAIN08_BUILDLINK3_MK

BUILDLINK_TREE+=	-libchamplain08
