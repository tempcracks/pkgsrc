# $NetBSD: buildlink3.mk,v 1.14 2010/01/17 12:02:09 wiz Exp $

BUILDLINK_TREE+=	mysql-client

.if !defined(MYSQL_CLIENT_BUILDLINK3_MK)
MYSQL_CLIENT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.mysql-client+=	mysql-client>=5.0.15
BUILDLINK_ABI_DEPENDS.mysql-client+=	mysql-client>=5.0.88
BUILDLINK_PKGSRCDIR.mysql-client?=	../../databases/mysql5-client
BUILDLINK_LIBDIRS.mysql-client?=	lib/mysql
BUILDLINK_INCDIRS.mysql-client?=	include/mysql

.include "../../security/openssl/buildlink3.mk"
.include "../../devel/zlib/buildlink3.mk"
.endif # MYSQL_CLIENT_BUILDLINK3_MK

BUILDLINK_TREE+=	-mysql-client
