$NetBSD: patch-src_jv__print.c,v 1.1 2018/05/30 16:03:48 ginsbach Exp $

CVE-2016-4074

From 83e2cf607f3599d208b6b3129092fa7deb2e5292 Mon Sep 17 00:00:00 2001
From: W-Mark Kubacki <wmark@hurrikane.de>
Date: Fri, 19 Aug 2016 19:50:39 +0200
Subject: [PATCH] Skip printing what's below a MAX_PRINT_DEPTH

This addresses #1136, and mitigates a stack exhaustion when printing
a very deeply nested term.
---
 src/jv_print.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/jv_print.c b/src/jv_print.c
index 5f4f234b..ce4a59af 100644
--- jv_print.c
+++ jv_print.c
@@ -13,6 +13,10 @@
 #include "jv_dtoa.h"
 #include "jv_unicode.h"
 
+#ifndef MAX_PRINT_DEPTH
+#define MAX_PRINT_DEPTH (256)
+#endif
+
 #define ESC "\033"
 #define COL(c) (ESC "[" c "m")
 #define COLRESET (ESC "[0m")
@@ -150,7 +154,9 @@ static void jv_dump_term(struct dtoa_context* C, jv x, int flags, int indent, FI
       }
     }
   }
-  switch (jv_get_kind(x)) {
+  if (indent > MAX_PRINT_DEPTH) {
+    put_str("<skipped: too deep>", F, S, flags & JV_PRINT_ISATTY);
+  } else switch (jv_get_kind(x)) {
   default:
   case JV_KIND_INVALID:
     if (flags & JV_PRINT_INVALID) {
