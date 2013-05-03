# $NetBSD: msgfmt-msgctxt.awk,v 1.4 2013/05/03 12:31:43 obache Exp $
#
# Simple awk script to strip out .po entries with msgctxt and "#~|", so the
# resultant file can be handled by the msgfmt<0.15.
# Additionally, normalize EOL style by stripping \r.

BEGIN {
	EMPTY = "^$"
	SPACE = "[ 	]*"
	KEYWORD_SEP = "([ 	]+|[ 	]*\"|$)"
	OBSOLETE = "#~ "
	OBSOLETE_RE = "^(#~[ 	]+)?[ 	]*"
	OBSOLETE_RE_MATCH = "^#~[ 	]+"
	MSG_CONTINUATION_RE = OBSOLETE_RE "\""

	result = getline
	if (result < 1) exit result

	s = 0
	p = 0
	obsolete = ""

	while (result == 1) {

		# Buffer any "msgctxt" statements into the singular array.
		# Strip all trailing empty strings that have no effect on
		# the output.
		#
		MSGCTXT_RE = OBSOLETE_RE "msgctxt"
		if ($0 ~ MSGCTXT_RE KEYWORD_SEP) {
			obsolete = ""
			if ($0 ~ OBSOLETE_RE_MATCH) obsolete = OBSOLETE
			sub(MSGCTXT_RE SPACE, "");
			s = 0
			if ($0 ~ EMPTY) $0 = "\"\""
			sub(/\r$/, "")
			singular[s++] = $0
			while (result = getline) {
				if ($0 ~ OBSOLETE_RE "$") continue
				if ($0 !~ MSG_CONTINUATION_RE) break
				sub(OBSOLETE_RE , "")
				sub(/\r$/, "")
				singular[s++] = $0
			}
			if (result < 0) break
			while ((s > 1) && (singular[s-1] ~ /^""$/)) s--
			continue
		}

		# If we see "msgid", then we are outputting the
		# context of a singular form of a message, so dump
		# the contents of the singular array as "msgid"
		# and output magic word "\004" then continue to output
		# subsequent "msgid".  Strip all trailing empty strings
		# that have no effect on the output, and handle "\n"
		# pickiness between msgctxt and msgid.
		#
		MSGID_RE = OBSOLETE_RE "msgid"
		if ($0 ~ MSGID_RE KEYWORD_SEP) {
			if (s > 0) {
				print obsolete "msgid " singular[0]
				for (i = 1; i < s; i++)
					print obsolete singular[i]
				print obsolete "\"\\004\""
			}
			if ($0 ~ OBSOLETE_RE_MATCH) obsolete = OBSOLETE
			sub(MSGID_RE SPACE, "")
			t = 0
			if ($0 ~ EMPTY) $0 = "\"\""
			sub(/\r$/, "")
			msgid[t++] = $0
			while (result = getline) {
				if ($0 !~ MSG_CONTINUATION_RE) break
				sub(OBSOLETE_RE, "")
				sub(/\r$/, "")
				msgid[t++] = $0
			}
			if (result < 0) break
			while ((t > 1) && (msgid[t-1] ~ /^""$/)) t--
			if ((singular[s-1] ~ /\\n"$/) &&
			    (msgid[t-1] !~ /\\n"$/)) {
				if (msgid[t-1] !~ /""/)
					sub("\"$", "\\n\"", msgid[t-1])
			}
			if (t > 0) {
				if (s > 0) {
					print obsolete msgid[0]
				} else {
					print obsolete "msgid " msgid[0]
				}
				for (i = 1; i < t; i++)
					print obsolete msgid[i]
			}
			s = 0
			continue
		}

		# Pass everything else verbatim.
		if ($0 !~ /^#~\|/) {
			sub(/\r$/, "")
			print $0
		}
		result = getline
		if (result < 0) break
	}
}
