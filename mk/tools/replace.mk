# $NetBSD: replace.mk,v 1.7 2005/04/24 03:07:36 jlam Exp $
#
# This Makefile fragment handles "replacements" of system-supplied
# tools with pkgsrc versions.  The replacements are placed under
# ${TOOLS_DIR} so that they appear earlier in the search path when
# invoked using the bare name of the tool.  Also, any "TOOL" variables,
# e.g. AWK, SED, etc. are set properly to the replacement tool.
#
# The tools that could be replaced with pkgsrc counterparts (usually
# GNU versions of the tools) should be listed in each package Makefile
# as:
#
#	USE_TOOLS+=	awk gmake lex
#
# If a package requires yacc to generate a parser, then the package
# Makefile should contain one of the following two lines:
#
#	USE_TOOLS+=	yacc	# any yacc will do
#	USE_TOOLS+=	bison	# requires bison-specific features
#
# Adding either "yacc" or "bison" to USE_TOOLS will cause a "yacc" tool
# to be generated that may be used as a yacc-replacement.
#
# By default, any dependencies on the pkgsrc tools are build dependencies,
# but this may be changed by explicitly setting TOOLS_DEPENDS.<tool>,
# e.g.:
#
#	TOOLS_DEPENDS.tbl=	DEPENDS
#

# Continue to allow USE_GNU_TOOLS and USE_TBL until packages have been
# taught to use the new syntax.
#
.if defined(USE_GNU_TOOLS) && !empty(USE_GNU_TOOLS)
USE_TOOLS+=	${USE_GNU_TOOLS:S/make/gmake/}
.endif
.if defined(USE_TBL) && !empty(USE_TBL:M[yY][eE][sS])
USE_TOOLS+=	tbl
.endif

.if defined(USE_PERL5)
USE_TOOLS+=	perl
.endif

# Only allow one of "bison" and "yacc".
.if !empty(USE_TOOLS:Mbison) && !empty(USE_TOOLS:Myacc)
PKG_FAIL_REASON+=	"\`\`bison'' and \`\`yacc'' conflict in USE_TOOLS."
.endif

# This is an exhaustive list of tools for which we have pkgsrc
# replacements.
#
_TOOLS_REPLACE_LIST=	awk bison egrep fgrep file gmake grep lex m4	\
			patch perl sed tbl yacc

# "TOOL" variable names associated with each of the tools
_TOOLS_VARNAME.awk=	AWK
_TOOLS_VARNAME.bison=	YACC
_TOOLS_VARNAME.egrep=	EGREP
_TOOLS_VARNAME.fgrep=	FGREP
_TOOLS_VARNAME.file=	FILE_CMD
_TOOLS_VARNAME.gmake=	GMAKE
_TOOLS_VARNAME.grep=	GREP
_TOOLS_VARNAME.lex=	LEX
_TOOLS_VARNAME.m4=	M4
_TOOLS_VARNAME.patch=	PATCH
_TOOLS_VARNAME.perl=	PERL5
_TOOLS_VARNAME.sed=	SED
_TOOLS_VARNAME.tbl=	TBL
_TOOLS_VARNAME.yacc=	YACC

######################################################################

# For each tool, _TOOLS_USE_PLATFORM.<tool> is a list of platforms for
# which we will use the system-supplied tool instead of the pkgsrc
# version.
#
# This table should probably be split amongst the various mk/platform
# files as they are ${OPSYS}-specific.
#
_TOOLS_USE_PLATFORM.awk=	FreeBSD-*-* Linux-*-* OpenBSD-*-*	\
				NetBSD-1.[0-6]*-* DragonFly-*-*		\
				SunOS-*-* Interix-*-*
_TOOLS_USE_PLATFORM.bison=	Linux-*-*
_TOOLS_USE_PLATFORM.egrep=	Darwin-*-* FreeBSD-*-* Linux-*-*	\
				NetBSD-*-* OpenBSD-*-* DragonFly-*-*	\
				SunOS-*-*
_TOOLS_USE_PLATFORM.fgrep=	Darwin-*-* FreeBSD-*-* Linux-*-*	\
				NetBSD-*-* OpenBSD-*-* DragonFly-*-*	\
				SunOS-*-*
_TOOLS_USE_PLATFORM.file=	Darwin-*-* FreeBSD-*-* Linux-*-*	\
				NetBSD-*-* OpenBSD-*-* DragonFly-*-*	\
				SunOS-*-*
_TOOLS_USE_PLATFORM.gmake=	Darwin-*-*
_TOOLS_USE_PLATFORM.grep=	Darwin-*-* FreeBSD-*-* Linux-*-*	\
				NetBSD-*-* OpenBSD-*-* DragonFly-*-*	\
				SunOS-*-*
_TOOLS_USE_PLATFORM.lex=	FreeBSD-*-* Linux-*-* NetBSD-*-*	\
				OpenBSD-*-* DragonFly-*-*
_TOOLS_USE_PLATFORM.m4=		# empty
_TOOLS_USE_PLATFORM.patch=	Darwin-*-* FreeBSD-*-* Linux-*-*	\
				NetBSD-*-* OpenBSD-*-* DragonFly-*-*	\
				SunOS-*-*
_TOOLS_USE_PLATFORM.perl=	# This should always be empty.
_TOOLS_USE_PLATFORM.sed=	FreeBSD-*-* Linux-*-* NetBSD-*-*	\
				DragonFly-*-* SunOS-*-* Interix-*-*
_TOOLS_USE_PLATFORM.tbl=	FreeBSD-*-* NetBSD-*-* OpenBSD-*-*	\
				DragonFly-*-*
_TOOLS_USE_PLATFORM.yacc=	FreeBSD-*-* NetBSD-*-* OpenBSD-*-*	\
				DragonFly-*-*

######################################################################

# _TOOLS_USE_PKGSRC.<prog> is "yes" or "no" depending on whether we're
# using a pkgsrc-supplied tool to replace the system-supplied one.
#
# This currently uses ${OPSYS}-based checking and ignores the scenario
# where your kernel and userland aren't in sync.  This should be turned
# into a bunch of feature tests in the future.
#
.for _t_ in ${_TOOLS_REPLACE_LIST}
.  for _pattern_ in ${_TOOLS_USE_PLATFORM.${_t_}}
.    if !empty(MACHINE_PLATFORM:M${_pattern_})
_TOOLS_USE_PKGSRC.${_t_}?=	no
.    endif
.  endfor
.  undef _pattern_
_TOOLS_USE_PKGSRC.${_t_}?=	yes
.endfor
.undef _t_

# TOOLS_DEPENDS.<prog> defaults to BUILD_DEPENDS.
.for _t_ in ${_TOOLS_REPLACE_LIST}
TOOLS_DEPENDS.${_t_}?=	BUILD_DEPENDS
.endfor
.undef _t_

######################################################################

# For each of the blocks below, we create either symlinks or wrappers
# for each of the tools requested.  We need to be careful that we don't
# get into dependency loops; do this by setting and checking the value
# of TOOLS_IGNORE.<tool>.  If we're using the system-supplied tool, we
# defer the setting of TOOLS_REAL_CMD.<tool> until the loop at the end.
#
.if !defined(TOOLS_IGNORE.awk) && !empty(USE_TOOLS:Mawk)
.  if !empty(PKGPATH:Mlang/gawk)
MAKEFLAGS+=			TOOLS_IGNORE.awk=
.  elif !empty(_TOOLS_USE_PKGSRC.awk:M[yY][eE][sS])
${TOOLS_DEPENDS.awk}+=		gawk>=3.1.1:../../lang/gawk
TOOLS_SYMLINK+=			awk
TOOLS_REAL_CMD.awk=		${LOCALBASE}/bin/${GNU_PROGRAM_PREFIX}awk
.    if exists(${TOOLS_REAL_CMD.awk})
${_TOOLS_VARNAME.awk}=		${TOOLS_REAL_CMD.awk}
.    endif
.  endif
TOOLS_CMD.awk=			${TOOLS_DIR}/bin/awk
.endif

.if !defined(TOOLS_IGNORE.bison) && !empty(USE_TOOLS:Mbison)
.  if !empty(PKGPATH:Mdevel/bison)
MAKEFLAGS+=			TOOLS_IGNORE.bison=
.  elif !empty(_TOOLS_USE_PKGSRC.bison:M[yY][eE][sS])
${TOOLS_DEPENDS.bison}+=	bison>=1.0:../../devel/bison
TOOLS_WRAP+=			bison
TOOLS_REAL_CMD.bison=		${LOCALBASE}/bin/bison
TOOLS_ARGS.bison=		-y
.    if exists(${TOOLS_REAL_CMD.bison})
${_TOOLS_VARNAME.bison}=	${TOOLS_REAL_CMD.bison} ${TOOLS_ARGS.bison}
.    endif
.  endif
TOOLS_CMD.bison=		${TOOLS_DIR}/bin/yacc
.endif

.if !defined(TOOLS_IGNORE.file) && !empty(USE_TOOLS:Mfile)
.  if !empty(PKGPATH:Msysutils/file)
MAKEFLAGS+=			TOOLS_IGNORE.file=
.  elif !empty(_TOOLS_USE_PKGSRC.file:M[yY][eE][sS])
${TOOLS_DEPENDS.file}+=		file>=4.13:../../sysutils/file
TOOLS_SYMLINK+=			file
TOOLS_REAL_CMD.file=		${LOCALBASE}/bin/file
.    if exists(${TOOLS_REAL_CMD.file})
${_TOOLS_VARNAME.file}=	${TOOLS_REAL_CMD.file}
.    endif
.  endif
TOOLS_CMD.file=			${TOOLS_DIR}/bin/file
.endif

.if !defined(TOOLS_IGNORE.gmake) && !empty(USE_TOOLS:Mgmake)
.  if !empty(PKGPATH:Mdevel/gmake)
MAKEFLAGS+=			TOOLS_IGNORE.gmake=
.  elif !empty(_TOOLS_USE_PKGSRC.gmake:M[yY][eE][sS])
${TOOLS_DEPENDS.gmake}+=	gmake>=3.78:../../devel/gmake
TOOLS_SYMLINK+=			gmake
TOOLS_REAL_CMD.gmake=		${LOCALBASE}/bin/gmake
.    if exists(${TOOLS_REAL_CMD.gmake})
${_TOOLS_VARNAME.gmake}=	${TOOLS_REAL_CMD.gmake}
.    endif
.  endif
TOOLS_CMD.gmake=		${TOOLS_DIR}/bin/gmake
.endif

.if (!defined(TOOLS_IGNORE.egrep) && !empty(USE_TOOLS:Megrep)) || \
    (!defined(TOOLS_IGNORE.fgrep) && !empty(USE_TOOLS:Mfgrep)) || \
    (!defined(TOOLS_IGNORE.grep) && !empty(USE_TOOLS:Mgrep))
.  if !empty(PKGPATH:Mtextproc/grep)
MAKEFLAGS+=			TOOLS_IGNORE.egrep=
MAKEFLAGS+=			TOOLS_IGNORE.fgrep=
MAKEFLAGS+=			TOOLS_IGNORE.grep=
.  else
.    for _t_ in egrep fgrep grep
.      if empty(USE_TOOLS:M${_t_})
USE_TOOLS+=	${_t_}
.      endif
.    endfor
.    if !empty(_TOOLS_USE_PKGSRC.egrep:M[yY][eE][sS]) || \
        !empty(_TOOLS_USE_PKGSRC.fgrep:M[yY][eE][sS]) || \
        !empty(_TOOLS_USE_PKGSRC.grep:M[yY][eE][sS])
${TOOLS_DEPENDS.grep}+=		grep>=2.5.1:../../textproc/grep
TOOLS_SYMLINK+=			egrep fgrep grep
TOOLS_REAL_CMD.egrep=		${LOCALBASE}/bin/${GNU_PROGRAM_PREFIX}egrep
TOOLS_REAL_CMD.fgrep=		${LOCALBASE}/bin/${GNU_PROGRAM_PREFIX}fgrep
TOOLS_REAL_CMD.grep=		${LOCALBASE}/bin/${GNU_PROGRAM_PREFIX}grep
.      if exists(${TOOLS_REAL_CMD.egrep})
${_TOOLS_VARNAME.egrep}=	${TOOLS_REAL_CMD.egrep}
.      endif
.      if exists(${TOOLS_REAL_CMD.fgrep})
${_TOOLS_VARNAME.fgrep}=	${TOOLS_REAL_CMD.fgrep}
.      endif
.      if exists(${TOOLS_REAL_CMD.grep})
${_TOOLS_VARNAME.grep}=		${TOOLS_REAL_CMD.grep}
.      endif
.    endif
.  endif
TOOLS_CMD.egrep=		${TOOLS_DIR}/bin/egrep
TOOLS_CMD.fgrep=		${TOOLS_DIR}/bin/fgrep
TOOLS_CMD.grep=			${TOOLS_DIR}/bin/grep
.endif

.if !defined(TOOLS_IGNORE.lex) && !empty(USE_TOOLS:Mlex)
.  if !empty(PKGPATH:Mdevel/flex)
MAKEFLAGS+=			TOOLS_IGNORE.lex=
.  elif !empty(_TOOLS_USE_PKGSRC.lex:M[yY][eE][sS])
.    include "../../devel/flex/buildlink3.mk"
TOOLS_SYMLINK+=			lex
TOOLS_REAL_CMD.lex=		${LOCALBASE}/bin/flex
.    if exists(${TOOLS_REAL_CMD.lex})
${_TOOLS_VARNAME.lex}=		${TOOLS_REAL_CMD.lex}
.    endif
.  endif
TOOLS_CMD.lex=			${TOOLS_DIR}/bin/lex
.endif

.if !defined(TOOLS_IGNORE.m4) && !empty(USE_TOOLS:Mm4)
.  if !empty(PKGPATH:Mdevel/m4)
MAKEFLAGS+=			TOOLS_IGNORE.m4=
.  elif !empty(_TOOLS_USE_PKGSRC.m4:M[yY][eE][sS])
${TOOLS_DEPENDS.m4}+=		m4>=1.4:../../devel/m4
TOOLS_SYMLINK+=			m4
TOOLS_REAL_CMD.m4=		${LOCALBASE}/bin/gm4
.    if exists(${TOOLS_REAL_CMD.m4})
${_TOOLS_VARNAME.m4}=		${TOOLS_REAL_CMD.m4}
.    endif
.  endif
TOOLS_CMD.m4=			${TOOLS_DIR}/bin/m4
.endif

.if !defined(TOOLS_IGNORE.patch) && !empty(USE_TOOLS:Mpatch)
.  if !empty(PKGPATH:Mdevel/patch)
MAKEFLAGS+=			TOOLS_IGNORE.patch=
.  elif !empty(_TOOLS_USE_PKGSRC.patch:M[yY][eE][sS])
${TOOLS_DEPENDS.patch}+=	patch>=2.2:../../devel/patch
TOOLS_SYMLINK+=			patch
TOOLS_REAL_CMD.patch=		${LOCALBASE}/bin/gpatch
.    if exists(${TOOLS_REAL_CMD.patch})
${_TOOLS_VARNAME.patch}=	${TOOLS_REAL_CMD.patch}
.    endif
.  endif
TOOLS_CMD.patch=		${TOOLS_DIR}/bin/patch
.endif

.if !defined(TOOLS_IGNORE.perl) && !empty(USE_TOOLS:Mperl)
.  if !empty(PKGPATH:Mlang/perl5)
MAKEFLAGS+=			TOOLS_IGNORE.perl=
.  elif !empty(_TOOLS_USE_PKGSRC.perl:M[yY][eE][sS])
.    include "../../lang/perl5/buildlink3.mk"
TOOLS_SYMLINK+=			perl
TOOLS_REAL_CMD.perl=		${LOCALBASE}/bin/perl
.    if exists(${TOOLS_REAL_CMD.perl})
${_TOOLS_VARNAME.perl}=		${TOOLS_REAL_CMD.perl}
.    endif
.  endif
TOOLS_CMD.perl=			${TOOLS_DIR}/bin/perl
.endif

.if !defined(TOOLS_IGNORE.sed) && !empty(USE_TOOLS:Msed)
.  if !empty(PKGPATH:Mtextproc/sed)
MAKEFLAGS+=			TOOLS_IGNORE.sed=
.  elif !empty(_TOOLS_USE_PKGSRC.sed:M[yY][eE][sS])
${TOOLS_DEPENDS.sed}+=		gsed>=3.0.2:../../textproc/gsed
TOOLS_SYMLINK+=			sed
TOOLS_REAL_CMD.sed=		${LOCALBASE}/bin/${GNU_PROGRAM_PREFIX}sed
.    if exists(${TOOLS_REAL_CMD.sed})
${_TOOLS_VARNAME.sed}=		${TOOLS_REAL_CMD.sed}
.    endif
.  endif
TOOLS_CMD.sed=			${TOOLS_DIR}/bin/sed
.endif

.if !defined(TOOLS_IGNORE.tbl) && !empty(USE_TOOLS:Mtbl)
.  if !empty(PKGPATH:Mtextproc/groff)
MAKEFLAGS+=			TOOLS_IGNORE.tbl=
.  elif !empty(_TOOLS_USE_PKGSRC.tbl:M[yY][eE][sS])
${TOOLS_DEPENDS.tbl}+=		groff>=1.19nb4:../../textproc/groff
TOOLS_SYMLINK+=			tbl
TOOLS_REAL_CMD.tbl=		${LOCALBASE}/bin/tbl
.    if exists(${TOOLS_REAL_CMD.tbl})
${_TOOLS_VARNAME.tbl}=		${TOOLS_REAL_CMD.tbl}
.    endif
.  endif
TOOLS_CMD.tbl=			${TOOLS_DIR}/bin/tbl
.endif

.if !defined(TOOLS_IGNORE.yacc) && !empty(USE_TOOLS:Myacc)
.  if !empty(PKGPATH:Mdevel/bison)
MAKEFLAGS+=			TOOLS_IGNORE.yacc=
.  elif !empty(_TOOLS_USE_PKGSRC.yacc:M[yY][eE][sS])
${TOOLS_DEPENDS.yacc}+=		bison>=1.0:../../devel/bison
TOOLS_WRAP+=			yacc
TOOLS_REAL_CMD.yacc=		${LOCALBASE}/bin/bison
TOOLS_ARGS.yacc=		-y
.    if exists(${TOOLS_REAL_CMD.yacc})
${_TOOLS_VARNAME.yacc}=		${TOOLS_REAL_CMD.yacc} ${TOOLS_ARGS.yacc}
.    endif
.  endif
TOOLS_CMD.yacc=			${TOOLS_DIR}/bin/yacc
.endif

######################################################################

# Set TOOLS_REAL_CMD.<tool> appropriately in the case where we are
# using the system-supplied tool.  Here, we check to see if TOOL is
# defined.  If it is, then use that as the path to the real command
# and extract any arguments into TOOLS_ARGS.<tool>.  We also create
# either a wrapper or a symlink depending on whether there are any
# arguments or not.  Lastly, always set the TOOL name for each tool
# to point to the real command, e.g., TBL, YACC, etc.
#
.for _t_ in ${_TOOLS_REPLACE_LIST}
.  if !defined(TOOLS_IGNORE.${_t_}) && !empty(USE_TOOLS:M${_t_}) && \
      !empty(_TOOLS_USE_PKGSRC.${_t_}:M[nN][oO])
.    if defined(${_TOOLS_VARNAME.${_t_}})
TOOLS_REAL_CMD.${_t_}?=		\
	${${_TOOLS_VARNAME.${_t_}}:C/^/_asdf_/1:M_asdf_*:S/^_asdf_//}
TOOLS_ARGS.${_t_}?=		\
	${${_TOOLS_VARNAME.${_t_}}:C/^/_asdf_/1:N_asdf_*}
.      if !empty(TOOLS_ARGS.${_t_})
TOOLS_WRAP+=			${_t_}
${_TOOLS_VARNAME.${_t_}}=	${TOOLS_REAL_CMD.${_t_}} ${TOOLS_ARGS.${_t_}}
.      else
TOOLS_SYMLINK+=			${_t_}
${_TOOLS_VARNAME.${_t_}}=	${TOOLS_REAL_CMD.${_t_}}
.      endif
.    elif defined(TOOLS_REAL_CMD.${_t_})
${_TOOLS_VARNAME.${_t_}}=	${TOOLS_REAL_CMD.${_t_}} ${TOOLS_ARGS.${_t_}}
.    else
${_TOOLS_VARNAME.${_t_}}=	${_TOOLS_VARNAME.${_t_}}_not_defined_
.    endif
TOOLS_CMD.${_t_}?=		${TOOLS_DIR}/bin/${_t_}
.  endif
.endfor
.undef _t_
