# $NetBSD: var-scope-global.mk,v 1.1 2024/07/15 09:10:28 jperkin Exp $
#
# Tests for global variables, which are the most common variables.

# Global variables can be assigned and appended to.
GLOBAL=		value
GLOBAL+=	addition
.if ${GLOBAL} != "value addition"
.  error
.endif

# Global variables can be removed from their scope.
.undef GLOBAL
.if defined(GLOBAL)
.  error
.endif

all: .PHONY
