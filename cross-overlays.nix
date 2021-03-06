{ lib
, localSystem, crossSystem, config, overlays
}:

self: super: {
  libiconvReal =
    if crossSystem.isWasm
    then super.libiconvReal.overrideDerivation (attrs: {patches = [./libiconv-wasm32.patch];})
    else super.libiconvReal;
  libiconv = self.libiconvReal; # By default, this wants to pull stuff out of glibc or something

  haskell = let inherit (super) haskell; in haskell // {
    packages = haskell.packages // {
      ghcHEAD = haskell.packages.ghcHEAD.override (drv: {
        ghc = (drv.ghc.override {
          enableShared = false;
          enableRelocatedStaticLibs = false;
          enableIntegerSimple = true;
          withTerminfo = false;
          dontStrip = true;
          dontUseLibFFIForAdjustors = crossSystem.isWasm;
          disableFFI = crossSystem.isWasm;
          useLLVM = true;
          version = "8.5.20180424";
          buildLlvmPackages = self.buildPackages.llvmPackages_HEAD;
          llvmPackages = self.buildPackages.llvmPackages_HEAD;
        }).overrideAttrs (drv: {
          src =
            if !(crossSystem.isWasm)
              then drv.src
              else self.buildPackages.fetchgit {
                url = "https://github.com/WebGHC/ghc.git";
                rev = "b1115e8e2aef9d0ef0b278a5b9cc82d8ddaf195b";
                sha256 = "13n43hbxdwj134qgg7gdgyg69bbzjpj8w162bv0lbdm6rcjdpnmj";
                preFetch = ''
                  export HOME=$(pwd)
                  git config --global url."git://github.com/WebGHC/packages-".insteadOf     git://github.com/WebGHC/packages/
                  git config --global url."http://github.com/WebGHC/packages-".insteadOf    http://github.com/WebGHC/packages/
                  git config --global url."https://github.com/WebGHC/packages-".insteadOf   https://github.com/WebGHC/packages/
                  git config --global url."ssh://git@github.com/WebGHC/packages-".insteadOf ssh://git@github.com/WebGHC/packages/
                  git config --global url."git@github.com:WebGHC/packages-".insteadOf       git@github.com:WebGHC/packages/
                '';
              };
          # Use this to test nix-build on your local GHC checkout.
          # src = lib.cleanSource ./ghc;
          hardeningDisable = drv.hardeningDisable or []
            ++ ["stackprotector"]
            ++ lib.optional crossSystem.isWasm "pic";
          dontDisableStatic = true;
          NIX_NO_SELF_RPATH=1;
        });
        overrides = self.lib.composeExtensions (drv.overrides or (_:_:{})) (self: super: {
          mkDerivation = args: super.mkDerivation (args // {
            dontStrip = true;
            enableSharedExecutables = false;
            enableSharedLibraries = false;
            enableDeadCodeElimination = false;
            doHaddock = !crossSystem.isWasm;
            configureFlags = args.configureFlags or [] ++
              lib.optionals
                crossSystem.isWasm
                ["--ghc-option=-optl" "--ghc-option=-Wl,--export=main"];
          });
        });
      });
    };
  };
}

