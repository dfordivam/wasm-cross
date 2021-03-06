{ stdenv
, cmake
, sources
, libunwind
, llvm
, hostPlatform
, buildPlatform
, libcxx-headers
, lib
, enableSharedLibraries
}:

stdenv.mkDerivation {
  name = "libc++abi";

  src = sources.libcxxabi;

  nativeBuildInputs = [ cmake ];

  buildInputs = stdenv.lib.optional (!stdenv.isDarwin && !stdenv.isFreeBSD) libunwind;

  cmakeFlags = [
    "-DLLVM_CONFIG_PATH=${llvm}/bin/llvm-config"
    "-DLIBCXXABI_TARGET_TRIPLE=${hostPlatform.config}"
    "-DLIBCXXABI_LIBCXX_INCLUDES=${libcxx-headers}/include"
  ] ++ lib.optionals (hostPlatform != buildPlatform) [
    "-DUNIX=TRUE" # TODO: Figure out what this is about
  ];

  installPhase = if stdenv.isDarwin
    then ''
      for file in lib/*.dylib; do
        # this should be done in CMake, but having trouble figuring out
        # the magic combination of necessary CMake variables
        # if you fancy a try, take a look at
        # http://www.cmake.org/Wiki/CMake_RPATH_handling
        install_name_tool -id $out/$file $file
      done
      make install
      install -d 755 $out/include
      install -m 644 ../include/*.h $out/include
    ''
    else if enableSharedLibraries then ''
      install -d -m 755 $out/include $out/lib
      install -m 644 lib/libc++abi.so.1.0 $out/lib
      install -m 644 ../include/*.h $out/include
      ln -s libc++abi.so.1.0 $out/lib/libc++abi.so
      ln -s libc++abi.so.1.0 $out/lib/libc++abi.so.1
    ''
    else ''
      install -d -m 755 $out/include $out/lib
      install -m 644 ../include/*.h $out/include
      install -m 644 lib/libc++abi.a $out/lib
    '';

  meta = {
    homepage = http://libcxxabi.llvm.org/;
    description = "A new implementation of low level support for a standard C++ library";
    license = with stdenv.lib.licenses; [ ncsa mit ];
    maintainers = with stdenv.lib.maintainers; [ vlstill ];
    platforms = stdenv.lib.platforms.unix;
  };
}
