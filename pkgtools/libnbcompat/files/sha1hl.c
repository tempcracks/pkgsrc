/*	$NetBSD: sha1hl.c,v 1.3 2003/09/03 13:11:15 jlam Exp $	*/

/* sha1hl.c
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * <phk@login.dkuug.dk> wrote this file.  As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy me a beer in return.   Poul-Henning Kamp
 * ----------------------------------------------------------------------------
 */

/* #include "namespace.h" */

#if HAVE_CONFIG_H
#include "nbcompat/nbconfig.h"
#endif

#include "nbcompat/nbtypes.h"

#if HAVE_FCNTL_H
#include <fcntl.h>
#endif
#if HAVE_SYS_FILE_H
#include <sys/file.h>
#endif
#include <sys/uio.h>

#include <assert.h>
#include <errno.h>
#include <sha1.h>
#include <stdio.h>
#include <stdlib.h>
#if HAVE_UNISTD_H
#include <unistd.h>
#endif

#if defined(LIBC_SCCS) && !defined(lint)
__RCSID("$NetBSD: sha1hl.c,v 1.3 2003/09/03 13:11:15 jlam Exp $");
#endif /* LIBC_SCCS and not lint */

#ifndef _DIAGASSERT
#define _DIAGASSERT(cond)	assert(cond)
#endif

#if 0
__weak_alias(SHA1End,_SHA1End)
__weak_alias(SHA1File,_SHA1File)
__weak_alias(SHA1Data,_SHA1Data)
#endif

/* ARGSUSED */
char *
SHA1End(ctx, buf)
    SHA1_CTX *ctx;
    char *buf;
{
    int i;
    char *p = buf;
    u_char digest[20];
    static const char hex[]="0123456789abcdef";

    _DIAGASSERT(ctx != NULL);
    /* buf may be NULL */

    if (p == NULL && (p = malloc(41)) == NULL)
	return 0;

    SHA1Final(digest,ctx);
    for (i = 0; i < 20; i++) {
	p[i + i] = hex[((u_int32_t)digest[i]) >> 4];
	p[i + i + 1] = hex[digest[i] & 0x0f];
    }
    p[i + i] = '\0';
    return(p);
}

char *
SHA1File (filename, buf)
    char *filename;
    char *buf;
{
    u_char buffer[BUFSIZ];
    SHA1_CTX ctx;
    int fd, num, oerrno;

    _DIAGASSERT(filename != NULL);
    /* XXX: buf may be NULL ? */

    SHA1Init(&ctx);

    if ((fd = open(filename,O_RDONLY)) < 0)
	return(0);

    while ((num = read(fd, buffer, sizeof(buffer))) > 0)
	SHA1Update(&ctx, buffer, (size_t)num);

    oerrno = errno;
    close(fd);
    errno = oerrno;
    return(num < 0 ? 0 : SHA1End(&ctx, buf));
}

char *
SHA1Data (data, len, buf)
    const u_char *data;
    size_t len;
    char *buf;
{
    SHA1_CTX ctx;

    _DIAGASSERT(data != NULL);
    /* XXX: buf may be NULL ? */

    SHA1Init(&ctx);
    SHA1Update(&ctx, data, len);
    return(SHA1End(&ctx, buf));
}
