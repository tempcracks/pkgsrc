# $NetBSD: java-vm.mk,v 1.5 2003/01/29 09:34:32 abs Exp $
#
# This Makefile fragment handles Java dependencies and make variables,
# and is meant to be included by packages that require Java either at
# build-time or at run-time.  java-vm.mk will:
#
#	* set PKG_JVM and PKG_JAVA_HOME to the name of the JVM used and
#	  to the directory in which the JVM is installed, respectively;
#
#	* add a full dependency on the JRE and possibly a build dependency
#	  on the JDK, based on the value of USE_JAVA (if nonempty).  You
#	  must explicitly set USE_JAVA=run to _not_ add the build dependency
#	  on the JDK;
#
# There are three variables used to tweak the JVM selection:
#
# USE_JAVA2 is used to note that the package requires a Java2 implementation.
#	It's undefined by default, but may be set to "yes".
#
# PKG_JVM_DEFAULT is a user-settable variable whose value is the default
#	JVM to use.
#
# PKG_JVMS_ACCEPTED is a package-settable list of JVMs that may be used as
#	possible dependencies for the package.

.if !defined(JAVA_VM_MK)
JAVA_VM_MK=	# defined

.include "../../mk/bsd.prefs.mk"

# By default, assume we need the JDK.
USE_JAVA?=	yes
.if !empty(USE_JAVA:M[rR][uU][nN])
USE_JAVA=	run
.endif

PKG_JVM_DEFAULT?=	# empty
PKG_JVMS_ACCEPTED?=	${_PKG_JVMS}

# This is a list of all of the JVMs that may be used with java-vm.mk.
# Note: The wonka configuration is still under development
#
.if defined(USE_JAVA2) && !empty(USE_JAVA2:M[yY][eE][sS])
_PKG_JVMS?=		sun-jdk13 sun-jdk14 blackdown-jdk13 wonka
.else
_PKG_JVMS?=		jdk sun-jdk13 sun-jdk14 blackdown-jdk13 kaffe wonka
.endif

# To be deprecated: if PKG_JVM is explicitly set, then use it as the
# default JVM.  Note that this has lower precedence than PKG_JVM_DEFAULT.
#
.if defined(PKG_JVM)
.  if !empty(PKG_JVM)
_PKG_JVM_DEFAULT:=	${PKG_JVM}
.  endif
.endif

# Set the default JVM for this platform.
#
.if !empty(PKG_JVM_DEFAULT)
_PKG_JVM_DEFAULT=	${PKG_JVM_DEFAULT}
.endif
.if !defined(_PKG_JVM_DEFAULT)
.  if !empty(MACHINE_PLATFORM:MNetBSD-*-i386) || \
      !empty(MACHINE_PLATFORM:MLinux-*-i[3456]86)
_PKG_JVM_DEFAULT?=	jdk
.  elif !empty(MACHINE_PLATFORM:MNetBSD-*-powerpc)
_PKG_JVM_DEFAULT?=	blackdown-jdk13
.  elif !empty(MACHINE_PLATFORM:MDarwin-*-*)
_PKG_JVM_DEFAULT?=	sun-jdk
.  else
_PKG_JVM_DEFAULT?=	kaffe
.  endif
.endif

# These lists are copied from the JVM package Makefiles.
_ONLY_FOR_PLATFORMS.jdk= \
	NetBSD-*-i386 Linux-*-i[3-6]86
_ONLY_FOR_PLATFORMS.blackdown-jdk13= \
	NetBSD-*-i386 NetBSD-*-powerpc NetBSD-*-sparc \
	Linux-*-i[3-6]86 Linux-*-powerpc Linux-*-sparc
.if !empty(USE_JAVA:M[rR][uU][nN])
_ONLY_FOR_PLATFORMS.blackdown-jdk13+= \
	NetBSD-*-arm Linux-*-arm
.endif
_ONLY_FOR_PLATFORMS.sun-jdk13= \
	NetBSD-*-i386 Linux-*-i[3-6]86 Darwin-*-*
_ONLY_FOR_PLATFORMS.sun-jdk14= \
	NetBSD-1.5Z[A-Z]-i386 NetBSD-1.[6-9]*-i386 Linux-*-i[3-6]86
_ONLY_FOR_PLATFORMS.kaffe= \
	*-*-arm32 *-*-i386 *-*-m68k *-*-mips* *-*-sparc *-*-powerpc
_ONLY_FOR_PLATFORMS.wonka= \
	*-*-arm32 *-*-i386

# Set the accepted JVMs for this platform.
.for _jvm_ in ${_PKG_JVMS}
.  for _pattern_ in ${_ONLY_FOR_PLATFORMS.${_jvm_}}
.    if !empty(MACHINE_PLATFORM:M${_pattern_})
_PKG_JVMS_ACCEPTED+=	${PKG_JVMS_ACCEPTED:M${_jvm_}}
.    endif
.  endfor
.endfor

_JAVA_PKGBASE.jdk=		jdk
_JAVA_PKGBASE.sun-jdk13=	sun-jdk13
_JAVA_PKGBASE.sun-jdk14=	sun-jdk14
_JAVA_PKGBASE.blackdown-jdk13=	blackdown-jdk13
_JAVA_PKGBASE.kaffe=		kaffe
_JAVA_PKGBASE.wonka=		wonka

# Mark the acceptable JVMs and check which JVM packages are installed.
.for _jvm_ in ${_PKG_JVMS_ACCEPTED}
_PKG_JVM_OK.${_jvm_}=	yes
_PKG_JVM_INSTALLED.${_jvm_}!= \
	if ${PKG_INFO} -qe ${_JAVA_PKGBASE.${_jvm_}}; then		\
		${ECHO} yes;						\
	else								\
		${ECHO} no;						\
	fi
.endfor

# Convert "sun-jdk" into "sun-jdk13" or "sun-jdk14" depending on the
# platform.  Recent versions of NetBSD and Linux can use either the 1.3
# or 1.4 version of the Sun JDK, so default to the newer installed one.
#
.if ${_PKG_JVM_DEFAULT} == "sun-jdk"
.  if !empty(MACHINE_PLATFORM:MNetBSD-1.5Z[A-Z]-i386) || \
      !empty(MACHINE_PLATFORM:MNetBSD-1.[6-9]*-i386) || \
      !empty(MACHINE_PLATFORM:MLinux-*-i[3456]86)
.    if defined(_PKG_JVM_INSTALLED.sun-jdk14) && \
	(${_PKG_JVM_INSTALLED.sun-jdk14} == "yes")
_PKG_JVM_DEFAULT=	sun-jdk14
.    elif defined(_PKG_JVM_INSTALLED.sun-jdk13) && \
	  (${_PKG_JVM_INSTALLED.sun-jdk13} == "yes")
_PKG_JVM_DEFAULT=	sun-jdk13
.    else
_PKG_JVM_DEFAULT=	sun-jdk14
.    endif
.  elif !empty(MACHINE_PLATFORM:MNetBSD-*-i386) || \
	!empty(MACHINE_PLATFORM:MDarwin-*-*)
_PKG_JVM_DEFAULT=	sun-jdk13
.  endif
.endif

# Use one of the installed JVMs,...
#
.if !defined(_PKG_JVM)
.  for _jvm_ in ${_PKG_JVMS_ACCEPTED}
.    if !empty(_PKG_JVM_INSTALLED.${_jvm_}:M[yY][eE][sS])
_PKG_JVM?=	${_jvm_}
.    else
_PKG_JVM_FIRSTACCEPTED?= ${_jvm_}
.    endif
.  endfor
#
# ...otherwise, prefer the default one if it's accepted,...
#
.  if defined(_PKG_JVM_OK.${_PKG_JVM_DEFAULT}) && \
      !empty(_PKG_JVM_OK.${_PKG_JVM_DEFAULT}:M[yY][eE][sS])
_PKG_JVM=	${_PKG_JVM_DEFAULT}
.  endif
.endif
#
# ...otherwise, just use the first accepted JVM.
#
.if !defined(_PKG_JVM)
.  if defined(_PKG_JVM_FIRSTACCEPTED)
_PKG_JVM=	${_PKG_JVM_FIRSTACCEPTED}
.  endif
.endif
#
# If there are no acceptable JVMs, then generate an error.
#
.if !defined(_PKG_JVM)
# force an error
	error: no acceptable JVM found
.endif

BUILDLINK_DEPENDS.jdk?=			jdk-[0-9]*
BUILDLINK_DEPENDS.sun-jdk13?=		sun-jdk13-[0-9]*
BUILDLINK_DEPENDS.sun-jdk14?=		sun-jdk14-[0-9]*
BUILDLINK_DEPENDS.blackdown-jdk13?=	blackdown-jdk13-[0-9]*
BUILDLINK_DEPENDS.kaffe?=		kaffe-[0-9]*
BUILDLINK_DEPENDS.wonka?=		wonka-[0-9]*

_JAVA_BASE_CLASSES=	classes.zip

.if ${_PKG_JVM} == "jdk"
_JDK_PKGSRCDIR=		../../lang/jdk
_JRE_PKGSRCDIR=		../../lang/jdk
_JRE_DEPENDENCY=	jdk-[0-9]*:${_JRE_PKGSRCDIR}
_JAVA_HOME_DEFAULT=	${LOCALBASE}/java/jdk-1.1.8
.elif ${_PKG_JVM} == "sun-jdk13"
_JDK_PKGSRCDIR=		../../lang/sun-jdk13
_JRE_PKGSRCDIR=		../../lang/sun-jre13
_JRE_DEPENDENCY=	sun-jre13-[0-9]*:${_JRE_PKGSRCDIR}
_JAVA_HOME_DEFAULT=	${LOCALBASE}/java/sun-1.3.1
.elif ${_PKG_JVM} == "sun-jdk14"
_JDK_PKGSRCDIR=		../../lang/sun-jdk14
_JRE_PKGSRCDIR=		../../lang/sun-jre14
_JRE_DEPENDENCY=	sun-jre14-[0-9]*:${_JRE_PKGSRCDIR}
_JAVA_HOME_DEFAULT=	${LOCALBASE}/java/sun-1.4.0
UNLIMIT_RESOURCES+=	datasize
.elif ${_PKG_JVM} == "blackdown-jdk13"
_JDK_PKGSRCDIR=		../../lang/blackdown-jdk13
_JRE_PKGSRCDIR=		../../lang/blackdown-jre13
_JRE_DEPENDENCY=	blackdown-jre13-[0-9]*:${_JRE_PKGSRCDIR}
_JAVA_HOME_DEFAULT=	${LOCALBASE}/java/blackdown-1.3.1
. if !empty(MACHINE_PLATFORM:MNetBSD-*-powerpc)
MAKE_ENV+=		THREADS_FLAG="green"
CONFIGURE_ENV+=		THREADS_FLAG="green"
SCRIPTS_ENV+=		THREADS_FLAG="green"
. endif
.elif ${_PKG_JVM} == "kaffe"
_JDK_PKGSRCDIR=		../../lang/kaffe
_JRE_PKGSRCDIR=		../../lang/kaffe
_JRE_DEPENDENCY=	kaffe-[0-9]*:${_JRE_PKGSRCDIR}
_JAVA_HOME_DEFAULT=	${LOCALBASE}/java/kaffe
.elif ${_PKG_JVM} == "wonka"
_JDK_PKGSRCDIR=		../../lang/wonka
_JRE_PKGSRCDIR=		../../lang/wonka
_JRE_DEPENDENCY=	wonka-[0-9]*:${_JRE_PKGSRCDIR}
_JAVA_HOME_DEFAULT=	${LOCALBASE}/java/wonka
_JAVA_BASE_CLASSES=	wre.jar
SCRIPTS_ENV+=		JAVAC="jikes"
.endif
_JDK_DEPENDENCY?=	${BUILDLINK_DEPENDS.${_PKG_JVM}}:${_JDK_PKGSRCDIR}

EVAL_PREFIX+=		_JAVA_HOME=${_JAVA_PKGBASE.${_PKG_JVM}}

# We always need a run-time dependency on the JRE.
.if defined(USE_BUILDLINK2) && empty(USE_BUILDLINK2:M[nN][oO])
.  include "${_JRE_PKGSRCDIR}/buildlink2.mk"
.else
DEPENDS+=		${_JRE_DEPENDENCY}
.endif

# If we are building Java software, then we need a build-time dependency on
# the JDK.
#
.if empty(USE_JAVA:M[rR][uU][nN])
.  if defined(USE_BUILDLINK2) && empty(USE_BUILDLINK2:M[nN][oO])
.    include "${_JDK_PKGSRCDIR}/buildlink2.mk"
.  else
BUILD_DEPENDS+=		${_JDK_DEPENDENCY}
.  endif
.endif

# PKG_JVM is a publicly readable variable containing the name of the JVM
#	we will be using.
#
# PKG_JAVA_HOME is a publicly readable variable containing ${JAVA_HOME}
#	for the PKG_JVM described above.
#
PKG_JVM:=		${_PKG_JVM}
.if defined(BUILDLINK_JAVA_PREFIX.${_PKG_JVM})
PKG_JAVA_HOME?=		${BUILDLINK_JAVA_PREFIX.${_PKG_JVM}}
.else
PKG_JAVA_HOME?=		${_JAVA_HOME}
.endif
BUILD_DEFS+=		PKG_JVM PKG_JAVA_HOME
PATH:=			${PKG_JAVA_HOME}/bin:${PATH}

MAKE_ENV+=		JAVA_HOME=${PKG_JAVA_HOME}
CONFIGURE_ENV+=		JAVA_HOME=${PKG_JAVA_HOME}
SCRIPTS_ENV+=		JAVA_HOME=${PKG_JAVA_HOME}

.endif	# JAVA_VM_MK
