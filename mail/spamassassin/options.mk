# $NetBSD: options.mk,v 1.2 2004/11/17 19:56:49 xtraeme Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.spamassassin
PKG_SUPPORTED_OPTIONS=	ssl net-tests perl-warnings perl-taint-checks \
			awl-sql-tests bayes-sql-tests
#
# Default options
#
PKG_OPTIONS.spamassassin?=	perl-taint-checks perl-warnings ssl
.include "../../mk/bsd.options.mk"

#
# Build spamc and spamd with support for connections over SSL
#
.if !empty(PKG_OPTIONS:Mssl)
.  include "../../security/openssl/buildlink3.mk"
DEPENDS+=		p5-IO-Socket-SSL>=0.92:../../security/p5-IO-Socket-SSL
CONFIGURE_ARGS+=	--enable-ssl
MAKE_PARAMS+=		ENABLE_SSL=yes
.else
CONFIGURE_ARGS+=	--disable-ssl
MAKE_PARAMS+=		ENABLE_SSL=no
.endif

#
# Enable Internet based tests during 'make test' (Razor, Pyzor, etc.)
#
.if !empty(PKG_OPTIONS:Mnet-tests)
MAKE_PARAMS+=		RUN_NET_TESTS=yes
.else
MAKE_PARAMS+=		RUN_NET_TESTS=no
.endif

#
# Enable Perl warnings in spamd and spamassassin
#
.if !empty(PKG_OPTIONS:Mperl-warnings)
MAKE_PARAMS+=		PERL_WARN=yes
.else
MAKE_PARAMS+=		PERL_WARN=no
.endif

#
# Enable Perl taint checks in spamd and spamassassin to improve security
#
.if !empty(PKG_OPTIONS:Mperl-taint-checks)
MAKE_PARAMS+=		PERL_TAINT=yes
.else
MAKE_PARAMS+=		PERL_TAINT=no
.endif

#
# Enable tests of the SQL storage module for the automatic whitelist
# (AWL). This option enables interactive questions about the database
# configuration during 'configure' phase.
#
.if !empty(PKG_OPTIONS:Mawl-sql-tests)
MAKE_PARAMS+=		RUN_AWL_SQL_TESTS=yes
INTERACTIVE_STAGE+=	configure
.else
MAKE_PARAMS+=		RUN_AWL_SQL_TESTS=no
.endif

#
# Enable tests of the SQL storage module for Bayes information.
# This option enables interactive questions about the database
# configuration during 'configure' phase.
#
.if !empty(PKG_OPTIONS:Mbayes-sql-tests)
MAKE_PARAMS+=		RUN_BAYES_SQL_TESTS=yes
INTERACTIVE_STAGE+=	configure
.else
MAKE_PARAMS+=		RUN_BAYES_SQL_TESTS=no
.endif
