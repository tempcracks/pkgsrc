$NetBSD: patch-ipelib_ipeplatform.cpp,v 1.1 2019/01/01 16:30:29 wiz Exp $

Remove unused header that does not exist on NetBSD.

--- ipelib/ipeplatform.cpp.orig	2016-12-09 14:09:04.000000000 +0000
+++ ipelib/ipeplatform.cpp
@@ -38,7 +38,6 @@
 #include <gdiplus.h>
 #else
 #include <sys/wait.h>
-#include <xlocale.h>
 #include <dirent.h>
 #endif
 #ifdef __APPLE__
