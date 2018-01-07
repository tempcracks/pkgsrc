# $NetBSD: buildlink3.mk,v 1.16 2018/01/07 13:04:10 rillig Exp $

BUILDLINK_TREE+=	ptlib

.if !defined(PTLIB_BUILDLINK3_MK)
PTLIB_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ptlib+=	ptlib>=2.6.1
BUILDLINK_ABI_DEPENDS.ptlib+=	ptlib>=2.10.7nb10
BUILDLINK_PKGSRCDIR.ptlib?=	../../devel/ptlib

PTLIB_CONFIG?=	${BUILDLINK_PREFIX.ptlib}/bin/ptlib-config
CONFIGURE_ENV+=	PTLIB_CONFIG=${PTLIB_CONFIG:Q}

.include "../../devel/SDL/buildlink3.mk"
.include "../../databases/openldap-client/buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"
.include "../../textproc/expat/buildlink3.mk"
.include "../../mk/pthread.buildlink3.mk"
.endif # PTLIB_BUILDLINK3_MK

BUILDLINK_TREE+=	-ptlib
