require "mkmf"

unless have_header("ruby.h") && have_header("ruby/digest.h")
  raise "Can't find ruby.h & ruby/digest.h, try installing the ruby-dev headers"
end

CONFIG["optflags"] = "-O3"
$warnflags.sub!("-Wdeclaration-after-statement", "") # eg. RVM compiles Ruby with this set on some platforms, so it ends up in RbConfig::MAKEFILE_CONFIG
append_cflags("-std=c99")

# we can't let create_makefile default to compiling all source files in the directory, because then
# it won't set the appropriate flags for the different versions.  start by explicitly resetting the
# list to the files that we always want.  blake3_ruby.o is the only one we've implemented ourselves
# - the rest are the blake3_* files from https://github.com/BLAKE3-team/BLAKE3/tree/master/c.
$objs = %w(
  blake3_ruby.o
  blake3.o
  blake3_dispatch.o
  blake3_portable.o
)

$confs = []

def check_supported_flags(flags, obj_if_enabled, def_if_disabled)
  # run an arbitrary compilation test to see if these flags work; unfortunately there's no documented
  # mkmf method to do that, but all the have_ methods accept optional flags, so we use have_header.
  if have_header("blake3.h", nil, flags)
    # we have to explicitly add a compilation rule for the object file to inject the additional flags -
    # apart from the #{flags} subsitution, this is otherwise just what mkmf.rb puts in the .c.o rule.
    $confs << "#{obj_if_enabled}: #{obj_if_enabled[0..-2]}c\n\t$(ECHO) compiling $(<)\n\t$(Q) #{COMPILE_C.sub "$(CC)", "$(CC) #{flags}"}\n\n"
    $objs << obj_if_enabled
  else
    $defs << def_if_disabled
  end
end

check_supported_flags("-msse4.1",             "blake3_sse41.o",  "-DBLAKE3_NO_SSE41")
check_supported_flags("-mavx2",               "blake3_avx2.o",   "-DBLAKE3_NO_AVX2")
check_supported_flags("-mavx512f -mavx512vl", "blake3_avx512.o", "-DBLAKE3_NO_AVX512")

if have_header("arm_neon.h")
  $objs << "blake3_neon.o"
  $defs << "-DBLAKE3_USE_NEON"
end

create_makefile("digest/blake3") do |conf|
  # annoyingly, we have to repeat this line from the default output, so that it appears above the
  # defines we add below and therefore becomes the default target.  otherwise running 'make' with
  # no arguments builds the first of our .o files instead of the library.
  conf << "all:    $(DLLIB)\n"

  # then we can add our target definitions. we can't do this using the built-in mechanisms because
  # there's no way to specify different compilation flags _per file_, which we need to do to build
  # the multi-CPU support appropriately for blake3.
  conf << $confs.join
end
