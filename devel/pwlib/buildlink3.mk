# $NetBSD: buildlink3.mk,v 1.16 2010/01/17 12:02:14 wiz Exp $

BUILDLINK_TREE+=	pwlib

.if !defined(PWLIB_BUILDLINK3_MK)
PWLIB_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.pwlib+=	pwlib>=1.8.3nb1
BUILDLINK_ABI_DEPENDS.pwlib?=	pwlib>=1.8.3nb9
BUILDLINK_PKGSRCDIR.pwlib?=	../../devel/pwlib

.include "../../security/openssl/buildlink3.mk"
.include "../../mk/pthread.buildlink3.mk"
.endif # PWLIB_BUILDLINK3_MK

BUILDLINK_TREE+=	-pwlib
