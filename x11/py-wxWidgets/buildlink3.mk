# $NetBSD: buildlink3.mk,v 1.47 2018/01/07 13:04:41 rillig Exp $

BUILDLINK_TREE+=	${PYPKGPREFIX}-wxWidgets

.if !defined(PY_WXWIDGETS_BUILDLINK3_MK)
PY_WXWIDGETS_BUILDLINK3_MK:=

.include "../../lang/python/pyversion.mk"

BUILDLINK_API_DEPENDS.${PYPKGPREFIX}-wxWidgets+=	${PYPKGPREFIX}-wxWidgets>=2.6.1.0
BUILDLINK_ABI_DEPENDS.${PYPKGPREFIX}-wxWidgets+=	${PYPKGPREFIX}-wxWidgets>=2.8.10.1nb26
BUILDLINK_ABI_DEPENDS.${PYPKGPREFIX}-wxWidgets?=	${PYPKGPREFIX}-wxWidgets>=2.8.12.0nb6
BUILDLINK_PKGSRCDIR.${PYPKGPREFIX}-wxWidgets?=		../../x11/py-wxWidgets

.include "../../x11/wxGTK28/buildlink3.mk"
.endif # PY_WXWIDGETS_BUILDLINK3_MK

BUILDLINK_TREE+=	-${PYPKGPREFIX}-wxWidgets
