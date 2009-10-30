# $NetBSD: options.mk,v 1.2 2009/10/30 19:06:06 manu Exp $

PKG_OPTIONS_VAR=        PKG_OPTIONS.openvpn
PKG_SUPPORTED_OPTIONS=  pkcs11 pam
PKG_SUGGESTED_OPTIONS=

.include "../../mk/bsd.options.mk"

# include support for certificates on a stick (or card)

.if !empty(PKG_OPTIONS:Mpkcs11)
.include "../../security/pkcs11-helper/buildlink3.mk"
.else
# it would pick it up halfways when installed, and fail building
CONFIGURE_ARGS+= --disable-pkcs11
.endif

PLIST_VARS+=	pam
.if !empty(PKG_OPTIONS:Mpam)
USE_TOOLS+=	gmake
BUILD_DIRS+=	plugin/auth-pam
BUILD_TARGET=	
INSTALL_DIRS=	${WRKSRC}
INSTALL_TARGET=	install
PLIST.pam=	yes
post-install-pam:
	${INSTALL_LIB_DIR} ${DESTDIR}${PREFIX}/lib/openvpn && 	\
	cd ${WRKSRC:Q}/plugin/auth-pam &&			\
	${INSTALL_LIB} openvpn-auth-pam.so 			\
		       ${DESTDIR}${PREFIX}/lib/openvpn || true
.include "../../mk/pam.buildlink3.mk"
.else
post-install-pam:
.endif
