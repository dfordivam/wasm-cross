{ stdenv
, sources
, cmake
, zlib
, ncurses
, swig
, which
, libedit
, libxml2
, llvm
, clang-unwrapped
, python
, darwin
}:

stdenv.mkDerivation {
  name = "lldb";

  src = sources.lldb;

  patchPhase = ''
    # Fix up various paths that assume llvm and clang are installed in the same place
    sed -i 's,".*ClangConfig.cmake","${clang-unwrapped}/lib/cmake/clang/ClangConfig.cmake",' \
      cmake/modules/LLDBStandalone.cmake
    sed -i 's,".*tools/clang/include","${clang-unwrapped}/include",' \
      cmake/modules/LLDBStandalone.cmake
    sed -i 's,"$.LLVM_LIBRARY_DIR.",${llvm}/lib ${clang-unwrapped}/lib,' \
      cmake/modules/LLDBStandalone.cmake
  '';

  buildInputs = [ cmake python which swig ncurses zlib libedit libxml2 llvm ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.libobjc darwin.apple_sdk.libs.xpc ];

  CXXFLAGS = "-fno-rtti";
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLLDB_DISABLE_LIBEDIT=ON"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A next-generation high-performance debugger";
    homepage    = http://llvm.org/;
    license     = licenses.ncsa;
    platforms   = platforms.all;
  };
}
