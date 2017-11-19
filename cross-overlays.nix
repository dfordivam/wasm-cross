{ lib
, localSystem, crossSystem, config, overlays
}:

self: super: {
  haskellPackages = self.haskell.packages.ghcHEAD;
  haskell = let inherit (super) haskell; in haskell // {
    packages = haskell.packages // {
      ghcHEAD = haskell.packages.ghcHEAD.override (drv: {
        ghc = drv.ghc.override {
          enableShared = false;
          enableRelocatedStaticLibs = false;
          enableIntegerSimple = true;
          with-terminfo = false;
          dontStrip = true;
          # quick-cross = true; # Just for dev
        };
        overrides = self.lib.composeExtensions (drv.overrides or (_:_:{})) (self: super: {
          mkDerivation = args: super.mkDerivation (args // {
            enableExecutableStripping = false;
            enableLibraryStripping = false;
            enableSharedExecutables = false;
            enableSharedLibraries = false;
          });
        });
      });
    };
  };
}
