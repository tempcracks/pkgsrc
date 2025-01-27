# $NetBSD: varmod-to-lower.mk,v 1.1 2024/07/15 09:10:31 jperkin Exp $
#
# Tests for the :tl variable modifier, which converts the expression value
# to lowercase.
#
# TODO: What about non-ASCII characters? ISO-8859-1, UTF-8?

.if ${:UUPPER:tl} != "upper"
.  error
.endif

.if ${:Ulower:tl} != "lower"
.  error
.endif

.if ${:UMixeD case.:tl} != "mixed case."
.  error
.endif

# The ':tl' modifier works on the whole string, without splitting it into
# words.
.if ${:Umultiple   spaces:tl} != "multiple   spaces"
.  error
.endif

all: .PHONY
