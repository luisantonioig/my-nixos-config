{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, stdenv ? pkgs.stdenv
, fetchurl ? pkgs.fetchurl
}:

stdenv.mkDerivation rec {
  name = "my-node";
  version = "8.9.3";
  src = fetchurl {
    url = "https://github.com/IntersectMBO/cardano-node/releases/download/${version}/cardano-node-${version}-linux.tar.gz";
    sha256 = "sha256-qJYqMsAgqOU0sr2Ek1zofZV4gsuS2HqpRk/ixX1+7Rg=";
  };
  installPhase = ''
    tar -xzf $src
    mkdir -p $out/bin
    cp bin/cardano-node $out/bin
    cp bin/cardano-cli  $out/bin
  '';
}
