/* $NetBSD: dewey_cmp.c,v 1.2 2001/04/10 14:20:16 wennmach Exp $ */

/*
 * Implement the comparision of a package name with a dewey pattern
 * for use with PostgreSQL.
 *
 * Author: Lex Wennmacher,
 * almost entirely based on the dewey routines written by: Hubert Feyrer
 * (taken from: basesrc/usr.sbin/pkg_install/lib/str.c, version 1.28)
 */

#include <sys/cdefs.h>
#if 0
static const char *rcsid = "Id: str.c,v 1.5 1997/10/08 07:48:21 charnier Exp";
#else
__RCSID("$NetBSD: dewey_cmp.c,v 1.2 2001/04/10 14:20:16 wennmach Exp $");
#endif

/*
 * FreeBSD install - a package for the installation and maintainance
 * of non-core utilities.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * Jordan K. Hubbard
 * 18 July 1993
 *
 * Miscellaneous string utilities.
 *
 */

#include <sys/param.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <sys/queue.h>

#include <ctype.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <unistd.h>

#include <assert.h>
#include <err.h>
#include <fnmatch.h>

int     pmatch(const char *, const char *);

typedef enum deweyop_t {
	GT,
	GE,
	LT,
	LE
}       deweyop_t;

/*
 * Compare two dewey decimal numbers
 */
static int
deweycmp(char *a, deweyop_t op, char *b)
{
	int     ad;
	int     bd;
	char	*a_nb;
	char	*b_nb;
	int	in_nb = 0;
	int     cmp;

	assert(a != NULL);
	assert(b != NULL);

	/* Null out 'n' in any "nb" suffixes for initial pass */
	if ((a_nb = strstr(a, "nb")))
	    *a_nb = 0;
	if ((b_nb = strstr(b, "nb")))
	    *b_nb = 0;

	for (;;) {
		if (*a == 0 && *b == 0) {
			if (!in_nb && (a_nb || b_nb)) {
				/*
				 * If exact match on first pass, test
				 * "nb<X>" suffixes in second pass
				 */
				in_nb = 1;
				if (a_nb)
				    a = a_nb + 2;	/* Skip "nb" suffix */
				if (b_nb)
				    b = b_nb + 2;	/* Skip "nb" suffix */
			} else {
				cmp = 0;
				break;
			}
		}

		ad = bd = 0;
		for (; *a && *a != '.'; a++) {
			ad = (ad * 10) + (*a - '0');
		}
		for (; *b && *b != '.'; b++) {
			bd = (bd * 10) + (*b - '0');
		}
		if ((cmp = ad - bd) != 0) {
			break;
		}
		if (*a == '.')
			++a;
		if (*b == '.')
			++b;
	}
	/* Replace any nulled 'n' */
	if (a_nb)
		*a_nb = 'n';
	if (b_nb)
		*b_nb = 'n';
	return (op == GE) ? cmp >= 0 : (op == GT) ? cmp > 0 :
            (op == LE) ? cmp <= 0 : cmp < 0;
}

/*
 * Perform alternate match on "pkg" against "pattern",
 * calling pmatch (recursively) to resolve any other patterns.
 * Return 1 on match, 0 otherwise
 */
static int
alternate_match(const char *pattern, const char *pkg)
{
	char   *sep;
	char    buf[FILENAME_MAX];
	char   *last;
	char   *alt;
	char   *cp;
	int     cnt;
	int     found;

	if ((sep = strchr(pattern, '{')) == (char *) NULL) {
		errx(1, "alternate_match(): '{' expected in `%s'", pattern);
	}
	(void)strncpy(buf, pattern, (size_t) (sep - pattern));
	alt = &buf[sep - pattern];
	last = (char *) NULL;
	for (cnt = 0, cp = sep; *cp && last == (char *) NULL; cp++) {
		if (*cp == '{') {
			cnt++;
		} else if (*cp == '}' && --cnt == 0 && last == (char *) NULL) {
			last = cp + 1;
		}
	}
	if (cnt != 0) {
		errx(1, "Malformed alternate `%s'", pattern);
	}
	for (found = 0, cp = sep + 1; *sep != '}'; cp = sep + 1) {
		for (cnt = 0, sep = cp; cnt > 0 || (cnt == 0 && *sep != '}' &&
                    *sep != ','); sep++) {
			if (*sep == '{') {
				cnt++;
			} else if (*sep == '}') {
				cnt--;
			}
		}
		(void)snprintf(alt, sizeof(buf) - (alt - buf), "%.*s%s",
                    (int)(sep - cp), cp, last);
		if (pmatch(buf, pkg) == 1) {
			found = 1;
		}
	}
	return found;
}

/*
 * Perform dewey match on "pkg" against "pattern".
 * Return 1 on match, 0 otherwise
 */
static int
dewey_match(const char *pattern, const char *pkg)
{
	deweyop_t op;
	char   *cp;
	char   *sep;
	char   *ver;
	char    name[FILENAME_MAX];
	int     n;

	if ((sep = strpbrk(pattern, "<>")) == NULL) {
		errx(1, "dewey_match(): '<' or '>' expected in `%s'", pattern);
	}
	(void)snprintf(name, sizeof(name), "%.*s", (int)(sep - pattern),
            pattern);
	op = (*sep == '>') ? (*(sep + 1) == '=') ? GE : GT : (*(sep + 1) == '=')
            ? LE : LT;
	ver = (op == GE || op == LE) ? sep + 2 : sep + 1;
	n = (int) (sep - pattern);
	if ((cp = strrchr(pkg, '-')) != (char *) NULL) {
		if (strncmp(pkg, name, (size_t)(cp - pkg)) == 0 &&
                    n == cp - pkg) {
			if (deweycmp(cp + 1, op, ver)) {
				return 1;
			}
		}
	}
	return 0;
}

/*
 * Perform glob match on "pkg" against "pattern".
 * Return 1 on match, 0 otherwise
 */
static int
glob_match(const char *pattern, const char *pkg)
{
	return fnmatch(pattern, pkg, FNM_PERIOD) == 0;
}

/*
 * Perform simple match on "pkg" against "pattern". 
 * Return 1 on match, 0 otherwise
 */
static int
simple_match(const char *pattern, const char *pkg)
{
	return strcmp(pattern, pkg) == 0;
}

/*
 * Match pkg against pattern, return 1 if matching, 0 else
 */
int
pmatch(const char *pattern, const char *pkg)
{
	if (strchr(pattern, '{') != (char *) NULL) {
		/* emulate csh-type alternates */
		return alternate_match(pattern, pkg);
	}
	if (strpbrk(pattern, "<>") != (char *) NULL) {
		/* perform relational dewey match on version number */
		return dewey_match(pattern, pkg);
	}
	if (strpbrk(pattern, "*?[]") != (char *) NULL) {
		/* glob match */
		return glob_match(pattern, pkg);
	}
	
	/* no alternate, dewey or glob match -> simple compare */
	return simple_match(pattern, pkg);
}


/* pkg_cmp is used to implement the ~~~ operator in PostgreSQL */
#include <postgres.h>
#include <utils/builtins.h>

bool
pkg_cmp(text *vpkg, text *vpattern)
{
	char *pkg;
	char *pattern;
	int len;

/* Should never happen, but catch it anyway */
	if (vpkg == NULL || vpattern == NULL)
		return false;   

/*
 * Convert vpkg, vpattern from PostgreSQL built-in type "text"
 * to type "char *".
 * We wildly use "palloc" to allocate memory and never free it;
 * this ist done automatically by PostgreSQL after each transaction.
 */
        len = VARSIZE(vpkg) - VARHDRSZ;
        pkg = (char *)palloc(len + 1);
        memmove(pkg, VARDATA(vpkg), len);
        pkg[len] = '\0';  

        len = VARSIZE(vpattern) - VARHDRSZ;
        pattern = (char *)palloc(len + 1);
        memmove(pattern, VARDATA(vpattern), len);
        pattern[len] = '\0';  

	if (pmatch((const char *)pattern, (const char *)pkg) == 1)
		return true;

	return false;
}
