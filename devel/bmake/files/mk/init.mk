# SPDX-License-Identifier: BSD-2-Clause
#
# $Id: init.mk,v 1.3 2024/07/15 09:10:09 jperkin Exp $
#
#	@(#) Copyright (c) 2002-2024, Simon J. Gerraty
#
#	This file is provided in the hope that it will
#	be of use.  There is absolutely NO WARRANTY.
#	Permission to copy, redistribute or otherwise
#	use this file is hereby granted provided that
#	the above copyright notice and this notice are
#	left intact.
#
#	Please send copies of changes and bug-fixes to:
#	sjg@crufty.net
#

# should be set properly in sys.mk
_this ?= ${.PARSEFILE:S,bsd.,,}

.if !target(__${_this}__)
__${_this}__: .NOTMAIN

.if ${MAKE_VERSION:U0} > 20100408
_this_mk_dir := ${.PARSEDIR:tA}
.else
_this_mk_dir := ${.PARSEDIR}
.endif

.-include <local.init.mk>
.-include <${.CURDIR:H}/Makefile.inc>
.include <own.mk>
.include <compiler.mk>

# should have been set by sys.mk
CXX_SUFFIXES ?= .cc .cpp .cxx .C
CCM_SUFFIXES ?= .ccm
PCM ?= .pcm
# ${PICO} is used for PIC object files.
PICO ?= .pico

# SRCS which do not end up in OBJS
NO_OBJS_SRCS_SUFFIXES ?= .h ${CCM_SUFFIXES} .sh
OBJS_SRCS_FILTER += ${NO_OBJS_SRCS_SUFFIXES:@x@N*$x@:ts:}

.if defined(PROG_CXX) || ${SRCS:Uno:${CXX_SUFFIXES:S,^,N*,:ts:}} != ${SRCS:Uno:N/}
_CCLINK ?=	${CXX}
.endif
_CCLINK ?=	${CC}

.if !empty(WARNINGS_SET) || !empty(WARNINGS_SET_${MACHINE_ARCH})
.include <warnings.mk>
.endif

# these are applied in order, least specific to most
VAR_QUALIFIER_LIST += \
	${TARGET_SPEC_VARS:UMACHINE:@v@${$v}@} \
	${COMPILER_TYPE} \
	${.TARGET:T:R} \
	${.TARGET:T} \
	${.IMPSRC:T} \
	${VAR_QUALIFIER_XTRA_LIST}

QUALIFIED_VAR_LIST += \
	CFLAGS \
	COPTS \
	CPPFLAGS \
	CPUFLAGS \
	LDFLAGS \
	SRCS \

# a final :U avoids errors if someone uses :=
.for V in ${QUALIFIED_VAR_LIST:O:u:@q@$q $q_LAST@}
.for Q in ${VAR_QUALIFIER_LIST:u}
$V += ${$V_$Q:U${$V.$Q:U}} ${V_$Q_${COMPILER_TYPE}:U${$V.$Q.${COMPILER_TYPE}:U}}
.endfor
.endfor

CC_PG?= -pg
CXX_PG?= ${CC_PG}
CC_PIC?= -DPIC
CXX_PIC?= ${CC_PIC}
PROFFLAGS?= -DGPROF -DPROF

.if ${.MAKE.LEVEL:U1} == 0 && ${MK_DIRDEPS_BUILD:Uno} == "yes"
.if ${RELDIR} == "."
# top-level targets that are ok at level 0
DIRDEPS_BUILD_LEVEL0_TARGETS += clean* destroy*
M_ListToSkip?= O:u:S,^,N,:ts:
.if ${.TARGETS:Uall:${DIRDEPS_BUILD_LEVEL0_TARGETS:${M_ListToSkip}}} != ""
# this tells lib.mk and prog.mk to not actually build anything
_SKIP_BUILD = not building at level 0
.endif
.elif ${.TARGETS:U:Nall} == ""
_SKIP_BUILD = not building at level 0
# first .MAIN is what counts
.MAIN: dirdeps
.endif
.endif

.MAIN:		all

.if !defined(.PARSEDIR)
# no-op is the best we can do if not bmake.
.WAIT:
.endif

# define this once for consistency
.if !defined(_SKIP_BUILD)
# beforebuild is a hook for things that must be done early
all: beforebuild .WAIT realbuild
.else
all: .PHONY
.if !empty(_SKIP_BUILD) && ${.MAKEFLAGS:M-V} == ""
.warning ${_SKIP_BUILD}
.endif
.endif
beforebuild:
realbuild:

.endif
