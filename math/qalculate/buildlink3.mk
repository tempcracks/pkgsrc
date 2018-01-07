# $NetBSD: buildlink3.mk,v 1.18 2018/01/07 13:04:23 rillig Exp $

BUILDLINK_TREE+=	qalculate

.if !defined(QALCULATE_BUILDLINK3_MK)
QALCULATE_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.qalculate+=	qalculate>=0.8.2
BUILDLINK_ABI_DEPENDS.qalculate+=	qalculate>=0.9.7nb6
BUILDLINK_PKGSRCDIR.qalculate?=		../../math/qalculate

.include "../../devel/glib2/buildlink3.mk"
.include "../../math/cln/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.endif # QALCULATE_BUILDLINK3_MK

BUILDLINK_TREE+=	-qalculate
