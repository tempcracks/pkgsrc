#!@RCD_SCRIPTS_SHELL@
#
# $NetBSD: courierfilter.sh,v 1.3 2006/06/17 19:38:43 jlam Exp $
#
# Courier mail filter daemon
#
# PROVIDE: courierfilter
# REQUIRE: DAEMON
# KEYWORD: shutdown

. /etc/rc.subr

name="courierfilter"
rcvar=${name}
command="@PREFIX@/sbin/${name}"
pidfile="@VARBASE@/run/${name}.pid"

restart_cmd="courierfilter_doit restart"
start_precmd="courierfilter_prestart"
start_cmd="courierfilter_doit start"
stop_cmd="courierfilter_doit stop"

mkdir_perms() {
	dir="$1"; user="$2"; group="$3"; mode="$4"
	@TEST@ -d $dir || @MKDIR@ $dir
	@CHOWN@ $user $dir
	@CHGRP@ $group $dir
	@CHMOD@ $mode $dir
}

courierfilter_prestart() {
	# Courier filter directories
	mkdir_perms @COURIER_STATEDIR@/allfilters \
			@COURIER_USER@ @COURIER_GROUP@ 0750
	mkdir_perms @COURIER_STATEDIR@/filters \
			@COURIER_USER@ @COURIER_GROUP@ 0750
	mkdir_perms @PKG_SYSCONFDIR@/filters \
			@COURIER_USER@ @COURIER_GROUP@ 0750
	mkdir_perms @PKG_SYSCONFDIR@/filters/active \
			@COURIER_USER@ @COURIER_GROUP@ 0750
}

courierfilter_doit()
{
	action=$1

	case $action in
	restart)	@ECHO@ "Restarting ${name}." ;;
	start)		@ECHO@ "Starting ${name}." ;;
	stop)		@ECHO@ "Stopping ${name}." ;;
	esac

	${command} $action
}

load_rc_config $name
run_rc_command "$1"
