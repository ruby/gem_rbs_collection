require "mini_portile2"
require "stringio"

# @type var windows: Integer?
windows = MiniPortile.windows?
MiniPortile.mingw?
MiniPortile.mswin?
MiniPortile.darwin?
MiniPortile.freebsd?
MiniPortile.openbsd?
MiniPortile.linux?
MiniPortile.solaris?
# @type var target_os: String
target_os = MiniPortile.target_os
MiniPortile.target_cpu
# @type var native: String
native = MiniPortile.native_path("ports")
MiniPortile.posix_path("ports")

recipe = MiniPortile.new("libiconv", "1.17", logger: StringIO.new, cc_command: "clang",
                                             make_command: "make", open_timeout: 20, read_timeout: 20)
recipe.files << "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz"
recipe.files << { url: "https://example.com/foo-1.0.tar.gz", sha256: "0" * 64 }
recipe.patch_files << "patches/0001-fix.patch"
recipe.configure_options << "--disable-nls"
recipe.configure_options = ["--enable-static"]
recipe.target = "ports"
recipe.host = recipe.original_host
recipe.logger = $stdout

# @type var name: String
name = recipe.name
# @type var host: String?
host = recipe.host
# @type var options: Array[String]
options = recipe.configure_options
# @type var installed: bool
installed = recipe.installed?
recipe.downloaded?
recipe.configured?
# @type var path: String
path = recipe.path
recipe.include_path
recipe.lib_path
# @type var cc: String
cc = recipe.cc_cmd
recipe.gcc_cmd
recipe.cxx_cmd
recipe.make_cmd

local = MiniPortile.new("libfoo", "1.0")
local.source_directory = "/src/libfoo-1.0"
# @type var source_directory: String?
source_directory = local.source_directory
# @type var cooked: true
cooked = local.cook
local.activate
local.mkmf_config(pkg: "libfoo", static: "foo")

cmake = MiniPortileCMake.new("libbar", "2.0", cmake_command: "cmake3", cmake_build_type: "Debug")
cmake.system_name = "Linux"
# @type var cmake_cmd: String
cmake_cmd = cmake.cmake_cmd
cmake.cmake_build_type
# @type var defaults: Array[String]
defaults = cmake.configure_defaults
cmake.configure_prefix
cmake.make_cmd
# @type var configured: true?
configured = cmake.configure
