# $NetBSD: varmod-to-upper.mk,v 1.1 2024/07/15 09:10:31 jperkin Exp $
#
# Tests for the :tu variable modifier, which returns the words in the
# variable value, converted to uppercase.

.if ${:UUPPER:tu} != "UPPER"
.  error
.endif

.if ${:Ulower:tu} != "LOWER"
.  error
.endif

.if ${:UMixeD case.:tu} != "MIXED CASE."
.  error
.endif

# The :tu and :tl modifiers operate on the variable value as a single string,
# not as a list of words. Therefore, the adjacent spaces are preserved.
mod-tu-space:
	@echo $@: ${a   b:L:tu:Q}
