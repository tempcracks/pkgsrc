/*	NetBSD: acconfig.h,v 1.8 2005/06/25 06:14:08 lukem Exp	*/

@TOP@
@BOTTOM@

/* Define if your compiler supports `long long' */
#undef HAVE_LONG_LONG

/* Define if *printf() uses %qd to print `long long' (otherwise uses %lld) */
#undef HAVE_PRINTF_QD

/* Define if in_port_t exists */
#undef HAVE_IN_PORT_T

/* Define if sa_family_t exists in <sys/socket.h> */
#undef HAVE_SA_FAMILY_T

/* Define if struct sockaddr.sa_len exists (implies sockaddr_in.sin_len, etc) */
#undef HAVE_SOCKADDR_SA_LEN

/* Define if socklen_t exists */
#undef HAVE_SOCKLEN_T

/* Define if AF_INET6 exists in <sys/socket.h> */
#undef HAVE_AF_INET6

/* Define if `struct sockaddr_in6' exists in <netinet/in.h> */
#undef HAVE_SOCKADDR_IN6

/* Define if `struct addrinfo' exists in <netdb.h> */
#undef HAVE_ADDRINFO

/* Define if NS_IN6ADDRSZ exists in <arpa/nameser.h> */
#undef HAVE_NS_IN6ADDRSZ

/*
 * Define if <netdb.h> contains AI_NUMERICHOST et al.
 * Systems which only implement RFC2133 will need this.
 */
#undef HAVE_RFC2553_NETDB

/* Define if `struct direct' has a d_namlen element */
#undef HAVE_D_NAMLEN

/* Define if h_errno exists in <netdb.h> */
#undef HAVE_H_ERRNO_D

/* Define if dirname() is declared in <libgen.h> */
#undef HAVE_DIRNAME_D

/* Define if fclose() is declared in <stdio.h> */
#undef HAVE_FCLOSE_D

/* Define if getpass() is declared in <stdlib.h> or <unistd.h> */
#undef HAVE_GETPASS_D

/* Define if optarg is declared in <stdlib.h> or <unistd.h> */
#undef HAVE_OPTARG_D

/* Define if optind is declared in <stdlib.h> or <unistd.h> */
#undef HAVE_OPTIND_D

/* Define if pclose() is declared in <stdio.h> */
#undef HAVE_PCLOSE_D

/* Define if `long long' is supported and sizeof(off_t) >= 8 */
#undef HAVE_QUAD_SUPPORT

/* Define if strptime() is declared in <time.h> */
#undef HAVE_STRPTIME_D

/* Define if we have poll() and it is not emulated */
#undef HAVE_POLL

/* Define if we have struct pollfd in <poll.h> or <sys/poll.h> */
#undef HAVE_STRUCT_POLLFD

/*
 * Define this if compiling with SOCKS (the firewall traversal library).
 * Also, you must define connect, getsockname, bind, accept, listen, and
 * select to their SOCKS-versions.
 */
#undef	SOCKS
#undef	SOCKS4
#undef	SOCKS5
#undef	connect
#undef	getsockname
#undef	getpeername
#undef	bind
#undef	accept
#undef	listen
#undef	select
#undef	recvfrom
#undef	sendto
#undef	recv
#undef	send
#undef	read
#undef	write
#undef	rresvport
#undef	shutdown
#undef	close
#undef	dup
#undef	dup2
#undef	fclose
#undef	gethostbyname
