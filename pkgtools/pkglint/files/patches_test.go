package main

import "gopkg.in/check.v1"

// This is how each patch should look like.
func (s *Suite) Test_ChecklinesPatch__with_comment(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-WithComment",
		RcsID,
		"",
		"Text",
		"Text",
		"",
		"--- file.orig",
		"+++ file",
		"@@ -5,3 +5,3 @@",
		" context before",
		"-old line",
		"+new line",
		" context after")

	ChecklinesPatch(lines)

	t.CheckOutputEmpty()
}

// To make the patch comment clearly visible, it should be surrounded by empty lines.
// The missing empty lines are inserted by pkglint.
func (s *Suite) Test_ChecklinesPatch__without_empty_line__autofix(c *check.C) {
	t := s.Init(c)

	t.Chdir("category/package")
	patchLines := t.SetupFileLines("patch-WithoutEmptyLines",
		RcsID,
		"Text",
		"--- file.orig",
		"+++ file",
		"@@ -5,3 +5,3 @@",
		" context before",
		"-old line",
		"+new line",
		" context after")
	t.CreateFileLines("distinfo",
		RcsID,
		"",
		// The hash is taken from a breakpoint at the beginning of AutofixDistinfo, oldSha1
		"SHA1 (some patch) = 49abd735b7e706ea9ed6671628bb54e91f7f5ffb")

	t.SetupCommandLine("-Wall", "--autofix")
	G.Pkg = NewPackage(".")

	ChecklinesPatch(patchLines)

	t.CheckOutputLines(
		"AUTOFIX: patch-WithoutEmptyLines:1: Inserting a line \"\" after this line.",
		"AUTOFIX: patch-WithoutEmptyLines:3: Inserting a line \"\" before this line.",
		"AUTOFIX: distinfo:3: Replacing \"49abd735b7e706ea9ed6671628bb54e91f7f5ffb\" "+
			"with \"4938fc8c0b483dc2e33e741b0da883d199e78164\".")

	t.CheckFileLines("patch-WithoutEmptyLines",
		RcsID,
		"",
		"Text",
		"",
		"--- file.orig",
		"+++ file",
		"@@ -5,3 +5,3 @@",
		" context before",
		"-old line",
		"+new line",
		" context after")
	t.CheckFileLines("distinfo",
		RcsID,
		"",
		"SHA1 (some patch) = 4938fc8c0b483dc2e33e741b0da883d199e78164")
}

func (s *Suite) Test_ChecklinesPatch__no_comment_and_no_empty_lines(c *check.C) {
	t := s.Init(c)

	patchLines := t.SetupFileLines("patch-WithoutEmptyLines",
		RcsID,
		"--- file.orig",
		"+++ file",
		"@@ -1,1 +1,1 @@",
		"-old line",
		"+new line")

	ChecklinesPatch(patchLines)

	// These duplicate notes are actually correct. There should be an
	// empty line above the documentation and one below it. Since there
	// is no documentation yet, the line number for above and below is
	// the same. Outside of the testing environment, this duplicate
	// diagnostic is suppressed; see LogVerbose.
	t.CheckOutputLines(
		"NOTE: ~/patch-WithoutEmptyLines:1: Empty line expected after this line.",
		"ERROR: ~/patch-WithoutEmptyLines:2: Each patch must be documented.",
		"NOTE: ~/patch-WithoutEmptyLines:2: Empty line expected.")
}

func (s *Suite) Test_ChecklinesPatch__without_comment(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-WithoutComment",
		RcsID,
		"",
		"--- file.orig",
		"+++ file",
		"@@ -5,3 +5,3 @@",
		" context before",
		"-old line",
		"+old line",
		" context after")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"ERROR: patch-WithoutComment:3: Each patch must be documented.")
}

// Autogenerated git "comments" don't count as real comments since they
// don't convey any intention of a human developer.
func (s *Suite) Test_ChecklinesPatch__git_without_comment(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-aa",
		RcsID,
		"",
		"diff --git a/aa b/aa",
		"index 1234567..1234567 100644",
		"--- a/aa",
		"+++ b/aa",
		"@@ -1,1 +1,1 @@",
		"-old",
		"+new")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"ERROR: patch-aa:5: Each patch must be documented.")
}

func (s *Suite) Test_PatchChecker_checklineSourceAbsolutePathname(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-aa",
		RcsID,
		"",
		"Documentation",
		"",
		"--- code.c.orig",
		"+++ code.c",
		"@@ -0,0 +1,3 @@",
		"+const char abspath[] = PREFIX \"/bin/program\";",
		"+val abspath = libdir + \"/libiconv.so.1.0\"",
		"+const char abspath[] = \"/dev/scd0\";")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"WARN: patch-aa:10: Found absolute pathname: /dev/scd0")
}

func (s *Suite) Test_PatchChecker_checklineOtherAbsolutePathname(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-aa",
		RcsID,
		"",
		"Documentation",
		"",
		"--- file.unknown.orig",
		"+++ file.unknown",
		"@@ -0,0 +1,5 @@",
		"+abspath=\"@prefix@/bin/program\"",
		"+abspath=\"${DESTDIR}/bin/\"",
		"+abspath=\"${PREFIX}/bin/\"",
		"+abspath = $prefix + '/bin/program'",
		"+abspath=\"$prefix/bin/program\"")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"WARN: patch-aa:9: Found absolute pathname: /bin/")
}

// The output of BSD Make typically contains "*** Error code".
// In some really good patches, this output is included in the patch comment,
// to document why the patch is necessary.
func (s *Suite) Test_ChecklinesPatch__error_code(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-ErrorCode",
		RcsID,
		"",
		"*** Error code 1", // Looks like a context diff but isn't.
		"",
		"--- file.orig",
		"+++ file",
		"@@ -5,3 +5,3 @@",
		" context before",
		"-old line",
		"+old line",
		" context after")

	ChecklinesPatch(lines)

	t.CheckOutputEmpty()
}

func (s *Suite) Test_ChecklinesPatch__wrong_header_order(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-WrongOrder",
		RcsID,
		"",
		"Text",
		"Text",
		"",
		"+++ file",      // Wrong order
		"--- file.orig", // Wrong order
		"@@ -5,3 +5,3 @@",
		" context before",
		"-old line",
		"+old line",
		" context after")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"WARN: patch-WrongOrder:7: Unified diff headers should be first ---, then +++.")
}

// Context diffs are old and deprecated. Therefore pkglint doesn't check them thoroughly.
func (s *Suite) Test_ChecklinesPatch__context_diff(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-ctx",
		RcsID,
		"",
		"diff -cr history.c.orig history.c",
		"*** history.c.orig",
		"--- history.c")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"ERROR: patch-ctx:4: Each patch must be documented.",
		"WARN: patch-ctx:4: Please use unified diffs (diff -u) for patches.")
}

func (s *Suite) Test_ChecklinesPatch__no_patch(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-aa",
		RcsID,
		"",
		"-- oldfile",
		"++ newfile")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"ERROR: patch-aa: Contains no patch.")
}

func (s *Suite) Test_ChecklinesPatch__two_patched_files(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-aa",
		RcsID,
		"",
		"--- oldfile",
		"+++ newfile",
		"@@ -1 +1 @@",
		"-old",
		"+new",
		"--- oldfile2",
		"+++ newfile2",
		"@@ -1 +1 @@",
		"-old",
		"+new")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"ERROR: patch-aa:3: Each patch must be documented.",
		"WARN: patch-aa: Contains patches for 2 files, should be only one.")
}

// The patch headers are only recognized as such if they appear directly below each other.
func (s *Suite) Test_ChecklinesPatch__documentation_that_looks_like_patch_lines(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-aa",
		RcsID,
		"",
		"--- oldfile",
		"",
		"+++ newfile",
		"",
		"*** oldOrNewFile")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"ERROR: patch-aa: Contains no patch.")
}

func (s *Suite) Test_ChecklinesPatch__only_unified_header_but_no_content(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-unified",
		RcsID,
		"",
		"Documentation for the patch",
		"",
		"--- file.orig",
		"+++ file")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"ERROR: patch-unified:EOF: No patch hunks for \"file\".")
}

func (s *Suite) Test_ChecklinesPatch__only_context_header_but_no_content(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-context",
		RcsID,
		"",
		"Documentation for the patch",
		"",
		"*** file.orig",
		"--- file")

	ChecklinesPatch(lines)

	// Context diffs are deprecated, therefore it is not worth
	// adding extra code for checking them thoroughly.
	t.CheckOutputLines(
		"WARN: patch-context:5: Please use unified diffs (diff -u) for patches.")
}

// TODO: Maybe this should only be checked if the patch changes
// an absolute path to a relative one, because otherwise these
// absolute paths may be intentional.
func (s *Suite) Test_ChecklinesPatch__Makefile_with_absolute_pathnames(c *check.C) {
	t := s.Init(c)

	t.SetupCommandLine( /*none*/ )
	lines := t.NewLines("patch-unified",
		RcsID,
		"",
		"Documentation for the patch",
		"",
		"--- Makefile.orig",
		"+++ Makefile",
		"@@ -1,3 +1,7 @@",
		" \t/bin/cp context before",
		"-\t/bin/cp deleted",
		"+\t/bin/cp added",
		"+#\t/bin/cp added comment",
		"+# added comment",
		"+\t${DESTDIR}/bin/cp added",
		"+\t${prefix}/bin/cp added",
		" \t/bin/cp context after")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"WARN: patch-unified:10: Found absolute pathname: /bin/cp",
		"WARN: patch-unified:13: Found absolute pathname: /bin/cp")

	// With extra warnings turned on, absolute paths in the context lines
	// are also checked, to detect absolute paths that might be overlooked.
	G.Opts.WarnExtra = true

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"WARN: patch-unified:8: Found absolute pathname: /bin/cp",
		"WARN: patch-unified:10: Found absolute pathname: /bin/cp",
		"WARN: patch-unified:13: Found absolute pathname: /bin/cp",
		"WARN: patch-unified:15: Found absolute pathname: /bin/cp")
}

func (s *Suite) Test_ChecklinesPatch__no_newline_with_text_following(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-aa",
		RcsID,
		"",
		"comment",
		"",
		"--- oldfile",
		"+++ newfile",
		"@@ -1 +1 @@",
		"-old",
		"\\ No newline at end of file",
		"+new",
		"\\ No newline at end of file",
		"last line (a comment)")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"WARN: patch-aa:12: Empty line or end of file expected.")
}

func (s *Suite) Test_ChecklinesPatch__no_newline(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-aa",
		RcsID,
		"",
		"comment",
		"",
		"--- oldfile",
		"+++ newfile",
		"@@ -1 +1 @@",
		"-old",
		"\\ No newline at end of file",
		"+new",
		"\\ No newline at end of file")

	ChecklinesPatch(lines)

	t.CheckOutputEmpty()
}

// Some patch files may end before reaching the expected line count (in this case 7 lines).
// This is ok if only context lines are missing. These context lines are assumed to be empty lines.
func (s *Suite) Test_ChecklinesPatch__empty_lines_left_out_at_eof(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-aa",
		RcsID,
		"",
		"comment",
		"",
		"--- oldfile",
		"+++ newfile",
		"@@ -1,7 +1,6 @@",
		" 1",
		" 2",
		" 3",
		"-4",
		" 5",
		" 6") // Line 7 was empty, therefore omitted

	ChecklinesPatch(lines)

	t.CheckOutputEmpty()
}

// In some context lines, the leading space character may be missing.
// Since this is no problem for patch(1), pkglint also doesn't complain.
func (s *Suite) Test_ChecklinesPatch__context_lines_with_tab_instead_of_space(c *check.C) {
	t := s.Init(c)

	lines := t.NewLines("patch-aa",
		RcsID,
		"",
		"comment",
		"",
		"--- oldfile",
		"+++ newfile",
		"@@ -1,3 +1,3 @@",
		"\tcontext",
		"-old",
		"+new",
		"\tcontext")

	ChecklinesPatch(lines)

	t.CheckOutputEmpty()
}

// Must not panic.
func (s *Suite) Test_ChecklinesPatch__autofix_empty_patch(c *check.C) {
	t := s.Init(c)

	t.SetupCommandLine("-Wall", "--autofix")
	lines := t.NewLines("patch-aa",
		RcsID)

	ChecklinesPatch(lines)

	t.CheckOutputEmpty()
}

// Must not panic.
func (s *Suite) Test_ChecklinesPatch__autofix_long_empty_patch(c *check.C) {
	t := s.Init(c)

	t.SetupCommandLine("-Wall", "--autofix")
	lines := t.NewLines("patch-aa",
		RcsID,
		"")

	ChecklinesPatch(lines)

	t.CheckOutputEmpty()
}

func (s *Suite) Test_ChecklinesPatch__crlf(c *check.C) {
	t := s.Init(c)

	t.SetupCommandLine("-Wall", "--autofix")
	lines := t.SetupFileLines("patch-aa",
		RcsID,
		"",
		"Documentation",
		"",
		"--- oldfile",
		"+++ newfile",
		"@@ -1,1 +1,1 @@\r",
		"-old line",
		"+new line")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"AUTOFIX: ~/patch-aa:7: Replacing \"\\r\\n\" with \"\\n\".")
}

func (s *Suite) Test_ChecklinesPatch__autogenerated(c *check.C) {
	t := s.Init(c)

	lines := t.SetupFileLines("patch-aa",
		RcsID,
		"",
		"Documentation",
		"",
		"--- configure.orig",
		"+++ configure",
		"@@ -1,1 +1,1 @@",
		"-old line",
		"+: Avoid regenerating within pkgsrc")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"ERROR: ~/patch-aa:9: This code must not be included in patches.")
}

func (s *Suite) Test_ChecklinesPatch__empty_context_lines_in_hunk(c *check.C) {
	t := s.Init(c)

	lines := t.SetupFileLines("patch-aa",
		RcsID,
		"",
		"Documentation",
		"",
		"--- configure.orig",
		"+++ configure",
		"@@ -1,3 +1,3 @@",
		"",
		"-old line",
		"+new line")

	ChecklinesPatch(lines)

	// The first context line should start with a single space character,
	// but that would mean trailing white-space, so it may be left out.
	// The last context line is omitted completely because it would also
	// have trailing white-space, and if that were removed, would be a
	// trailing empty line.
	t.CheckOutputEmpty()
}

func (s *Suite) Test_ChecklinesPatch__invalid_line_in_hunk(c *check.C) {
	t := s.Init(c)

	lines := t.SetupFileLines("patch-aa",
		RcsID,
		"",
		"Documentation",
		"",
		"--- configure.orig",
		"+++ configure",
		"@@ -1,3 +1,3 @@",
		"",
		"-old line",
		"<<<<<<<<",
		"+new line")

	ChecklinesPatch(lines)

	// The first context line should start with a single space character,
	// but that would mean trailing white-space, so it may be left out.
	// The last context line is omitted completely because it would also
	// have trailing white-space, and if that were removed, would be a
	// trailing empty line.
	t.CheckOutputLines(
		"ERROR: ~/patch-aa:10: Invalid line in unified patch hunk: <<<<<<<<")
}

func (s *Suite) Test_PatchChecker_checklineAdded__shell(c *check.C) {
	t := s.Init(c)

	lines := t.SetupFileLines("patch-aa",
		RcsID,
		"",
		"Documentation",
		"",
		"--- configure.sh.orig",
		"+++ configure.sh",
		"@@ -1,1 +1,1 @@",
		"-old line",
		"+new line")

	ChecklinesPatch(lines)

	t.CheckOutputEmpty()
}

func (s *Suite) Test_PatchChecker_checklineAdded__text(c *check.C) {
	t := s.Init(c)

	lines := t.SetupFileLines("patch-aa",
		RcsID,
		"",
		"Documentation",
		"",
		"--- configure.tex.orig",
		"+++ configure.tex",
		"@@ -1,1 +1,1 @@",
		"-old line",
		"+new line")

	ChecklinesPatch(lines)

	t.CheckOutputEmpty()
}

func (s *Suite) Test_PatchChecker_checklineAdded__unknown(c *check.C) {
	t := s.Init(c)

	lines := t.SetupFileLines("patch-aa",
		RcsID,
		"",
		"Documentation",
		"",
		"--- configure.unknown.orig",
		"+++ configure.unknown",
		"@@ -1,1 +1,1 @@",
		"-old line",
		"+new line")

	ChecklinesPatch(lines)

	t.CheckOutputEmpty()
}

func (s *Suite) Test_PatchChecker_checktextRcsid(c *check.C) {
	t := s.Init(c)

	lines := t.SetupFileLines("patch-aa",
		RcsID,
		"",
		"Documentation",
		"",
		"--- configure.sh.orig",
		"+++ configure.sh",
		"@@ -1,3 +1,3 @@ $"+"Id$",
		" $"+"Id$",
		"-old line",
		"+new line",
		" $"+"Author: authorship $")

	ChecklinesPatch(lines)

	t.CheckOutputLines(
		"WARN: ~/patch-aa:7: Found RCS tag \"$"+"Id$\". Please remove it.",
		"WARN: ~/patch-aa:8: Found RCS tag \"$"+"Id$\". Please remove it by reducing the number of context lines using pkgdiff or \"diff -U[210]\".",
		"WARN: ~/patch-aa:11: Found RCS tag \"$"+"Author$\". Please remove it by reducing the number of context lines using pkgdiff or \"diff -U[210]\".")
}

func (s *Suite) Test_FileType_String(c *check.C) {
	c.Check(ftUnknown.String(), equals, "unknown")
}
