# $NetBSD: buildlink3.mk,v 1.17 2010/01/17 12:02:24 wiz Exp $

BUILDLINK_TREE+=	imap-uw

.if !defined(IMAP_UW_BUILDLINK3_MK)
IMAP_UW_BUILDLINK3_MK:=

.include "../../mk/bsd.fast.prefs.mk"

BUILDLINK_API_DEPENDS.imap-uw+=	imap-uw>=2007dnb1
BUILDLINK_ABI_DEPENDS.imap-uw+=	imap-uw>=2007enb1
BUILDLINK_PKGSRCDIR.imap-uw?=	../../mail/imap-uw
. if ${OPSYS} == "Darwin"
BUILDLINK_LDFLAGS.imap-uw+=	-flat_namespace
# install will strip the c-client library callback
# function symbols from the executable unless we do this:
INSTALL_UNSTRIPPED?=	yes
. endif

.include "../../security/openssl/buildlink3.mk"
.endif # IMAP_UW_BUILDLINK3_MK

BUILDLINK_TREE+=	-imap-uw
