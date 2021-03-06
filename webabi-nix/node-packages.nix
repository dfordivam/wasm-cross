# This file has been generated by node2nix 1.5.3. Do not edit!

{nodeEnv, fetchurl, fetchgit, globalBuildInputs ? []}:

let
  sources = {
    "async-2.6.0" = {
      name = "async";
      packageName = "async";
      version = "2.6.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/async/-/async-2.6.0.tgz";
        sha512 = "0zp4b5788400npi1ixjry5x3a4m21c8pnknk8v731rgnwnjbp5ijmfcf5ppmn1ap4a04md1s9dr8n9ygdvrmiai590v0k6dby1wc1y4";
      };
    };
    "browserfs-1.4.3" = {
      name = "browserfs";
      packageName = "browserfs";
      version = "1.4.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/browserfs/-/browserfs-1.4.3.tgz";
        sha512 = "39jq7fphcz7kwfcwqb7iiy3b47gfihlyhy5mr9rjdvj6d32kxzvlbzywp5wdcqpwjsqn16wm275qphkxg3vp26chmn35kbbal50fgxp";
      };
    };
    "lodash-4.17.5" = {
      name = "lodash";
      packageName = "lodash";
      version = "4.17.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/lodash/-/lodash-4.17.5.tgz";
        sha512 = "11hikgyas884mz8a58vyixaahxbpdwljdw4cb6qp15xa3sfqikp2mm6wgv41jsl34nzsv1hkx9kw3nwczvas5p73whirmaz4sxggwmj";
      };
    };
    "pako-1.0.6" = {
      name = "pako";
      packageName = "pako";
      version = "1.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/pako/-/pako-1.0.6.tgz";
        sha512 = "1r9hy37qsbhv5ipsydkbir2yl7qg3lbpgj4qzrnb903w8mhj9ibaww0zykbp0ak1nxxp6mpbws3xsrf7fgq39zchci90c7chgqvh1wm";
      };
    };
  };
  args = {
    name = "webabi";
    packageName = "webabi";
    version = "0.0.1";
    src = fetchgit {
      url = "https://github.com/WebGHC/webabi.git";
      rev = "7e70d2ea79f3d90ab9ba5638cb46d97a4e159150";
      sha256 = "0g6a4sg02r1skndjxa6n2af2mw375p3ca2p785hipkjl8z57vdjn";
    };
    dependencies = [
      sources."async-2.6.0"
      sources."browserfs-1.4.3"
      sources."lodash-4.17.5"
      sources."pako-1.0.6"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      license = "MIT";
    };
    production = true;
    bypassCache = true;
  };
in
{
  tarball = nodeEnv.buildNodeSourceDist args;
  package = nodeEnv.buildNodePackage args;
  shell = nodeEnv.buildNodeShell args;
}
