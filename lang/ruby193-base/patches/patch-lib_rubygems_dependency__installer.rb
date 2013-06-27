$NetBSD: patch-lib_rubygems_dependency__installer.rb,v 1.3 2013/06/27 16:35:44 taca Exp $

Add install_root option for pkgsrc's rubygems support.

--- lib/rubygems/dependency_installer.rb.orig	2011-07-27 02:04:03.000000000 +0000
+++ lib/rubygems/dependency_installer.rb
@@ -38,6 +38,7 @@ class Gem::DependencyInstaller
   # :format_executable:: See Gem::Installer#initialize.
   # :ignore_dependencies:: Don't install any dependencies.
   # :install_dir:: See Gem::Installer#install.
+  # :install_root: See Gem::Installer#install.
   # :prerelease:: Allow prerelease versions.  See #install.
   # :security_policy:: See Gem::Installer::new and Gem::Security.
   # :user_install:: See Gem::Installer.new
@@ -69,7 +70,12 @@ class Gem::DependencyInstaller
     @installed_gems = []
 
     @install_dir = options[:install_dir] || Gem.dir
-    @cache_dir = options[:cache_dir] || @install_dir
+    @install_root = options[:install_root]
+    install_dir = @install_dir
+    unless @install_root.nil? or @install_root == ""
+      install_dir = File.join(@install_root, @install_dir)
+    end
+    @cache_dir = options[:cache_dir] || install_dir
 
     # Set with any errors that SpecFetcher finds while search through
     # gemspecs for a dep
@@ -290,6 +296,7 @@ class Gem::DependencyInstaller
                                 :format_executable   => @format_executable,
                                 :ignore_dependencies => @ignore_dependencies,
                                 :install_dir         => @install_dir,
+                                :install_root        => @install_root,
                                 :security_policy     => @security_policy,
                                 :user_install        => @user_install,
                                 :wrappers            => @wrappers
