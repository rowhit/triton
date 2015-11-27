{ stdenv, fetchurl, libsigsegv, readline, readlineSupport ? false
, locale ? null }:

stdenv.mkDerivation rec {
  name = "gawk-4.1.3";

  src = fetchurl {
    url = "mirror://gnu/gawk/${name}.tar.xz";
    sha256 = "09d6pmx6h3i2glafm0jd1v1iyrs03vcyv2rkz12jisii3vlmbkz3";
  };

  doCheck = !(
       stdenv.isCygwin # XXX: `test-dup2' segfaults on Cygwin 6.1
    || stdenv.isDarwin # XXX: `locale' segfaults
    || stdenv.isSunOS  # XXX: `_backsmalls1' fails, locale stuff?
  );

  buildInputs = stdenv.lib.optional (stdenv.system != "x86_64-cygwin") libsigsegv
    ++ stdenv.lib.optional readlineSupport readline
    ++ stdenv.lib.optional stdenv.isDarwin locale;

  configureFlags = stdenv.lib.optional (stdenv.system != "x86_64-cygwin") "--with-libsigsegv-prefix=${libsigsegv}"
    ++ stdenv.lib.optional readlineSupport "--with-readline=${readline}"
      # only darwin where reported, seems OK on non-chrooted Fedora (don't rebuild stdenv)
    ++ stdenv.lib.optional (!readlineSupport && stdenv.isDarwin) "--without-readline";

  postInstall = "rm $out/bin/gawk-*";

  meta = {
    homepage = http://www.gnu.org/software/gawk/;
    description = "GNU implementation of the Awk programming language";

    longDescription = ''
      Many computer users need to manipulate text files: extract and then
      operate on data from parts of certain lines while discarding the rest,
      make changes in various text files wherever certain patterns appear,
      and so on.  To write a program to do these things in a language such as
      C or Pascal is a time-consuming inconvenience that may take many lines
      of code.  The job is easy with awk, especially the GNU implementation:
      Gawk.

      The awk utility interprets a special-purpose programming language that
      makes it possible to handle many data-reformatting jobs with just a few
      lines of code.
    '';

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
  };
}
