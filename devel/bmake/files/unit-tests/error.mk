# $NetBSD: error.mk,v 1.4 2024/07/15 09:10:20 jperkin Exp $
#
# Demonstrate that the .error directive exits immediately, without
# continuing parsing until the end of the file.

# expect+1: just FYI
.info just FYI
# expect+1: warning: this could be serious
.warning this could be serious
# expect+1: this is fatal
.error this is fatal
.info this is not reached because of the .error above

all:
	: this is not reached because of the .error
