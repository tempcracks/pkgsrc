/*	$NetBSD: function.c,v 1.1.1.1 2010/01/17 01:33:20 dholland Exp $	*/
/*	From NetBSD: function.c,v 1.6 2006/03/20 01:34:49 gdamore Exp 	*/

/*-
 * Copyright (c) 1988 The Regents of the University of California.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#ifndef HOST_TOOL
#include <sys/cdefs.h>
#ifndef lint
#if 0
static char sccsid[] = "@(#)function.c	4.2 (Berkeley) 4/26/91";
#else
__RCSID("$NetBSD: function.c,v 1.1.1.1 2010/01/17 01:33:20 dholland Exp $");
#endif
#endif /* not lint */
#endif

/*
 * This file, which never produces a function.o, is used solely to
 * be run through the preprocessor.
 *
 * On a 4.3 system (or even msdos), "cc -E function.h" would produce
 * the correct output.  Unfortunately, 4.2 compilers aren't quite that
 * useful.
 */

#include "function.h"
