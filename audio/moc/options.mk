# $NetBSD: options.mk,v 1.3 2008/04/07 16:15:25 bjs Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.moc
PKG_SUPPORTED_OPTIONS=	sndfile flac vorbis speex curl samplerate
PKG_SUGGESTED_OPTIONS=	sndfile flac vorbis curl

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Msamplerate)
PKG_OPTIONS+=		sndfile
CONFIGURE_ARGS+=	--with-samplerate
.  include "../../audio/libsamplerate/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--without-samplerate
.endif

.if !empty(PKG_OPTIONS:Msndfile) || defined(PKG_OPTIONS:Msamplerate)
PLIST_SUBST+=		SNDFILE=
CONFIGURE_ARGS+=	--with-sndfile
.  include "../../audio/libsndfile/buildlink3.mk"
.else
PLIST_SUBST+=		SNDFILE='@comment '
CONFIGURE_ARGS+=	--without-sndfile
.endif

.if !empty(PKG_OPTIONS:Mflac)
PLIST_SUBST+=		FLAC=
CONFIGURE_ARGS+=	--with-flac
.  include "../../audio/flac/buildlink3.mk"
.else
PLIST_SUBST+=		FLAC='@comment '
CONFIGURE_ARGS+=	--without-flac
.endif

.if !empty(PKG_OPTIONS:Mvorbis)
PLIST_SUBST+=		VORBIS=
CONFIGURE_ARGS+=	--with-vorbis
.  include "../../audio/libvorbis/buildlink3.mk"
.else
PLIST_SUBST+=		VORBIS='@comment '
CONFIGURE_ARGS+=	--without-vorbis
.endif

.if !empty(PKG_OPTIONS:Mspeex)
PLIST_SUBST+=		SPEEX=
CONFIGURE_ARGS+=	--with-speex
.  include "../../audio/speex/buildlink3.mk"
.else
PLIST_SUBST+=		SPEEX='@comment '
CONFIGURE_ARGS+=	--without-speex
.endif

.if !empty(PKG_OPTIONS:Mcurl)
CONFIGURE_ARGS+=	--with-curl
.  include "../../www/curl/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--without-curl
.endif
