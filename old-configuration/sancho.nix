{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, stdenv ? pkgs.stdenv
, fetchurl ? pkgs.fetchurl
}:

stdenv.mkDerivation rec {
  name = "sancho";
  version = "8.7.1-pre";
  src = fetchurl {
    url = "https://github.com/IntersectMBO/cardano-node/releases/download/8.8.1-pre/cardano-node-8.8.1-linux.tar.gz";
    sha256 = "sha256-TSA+s20xoL7WJnqdpsSVRJ1fZyipWUopfT0iM05e5Eo=";
  };
  installPhase = ''
    tar -xzf $src
    mkdir -p $out/bin
    cp cardano-node $out/bin/sancho-node
    cp cardano-cli  $out/bin/sancho-cli
    cp cardano-submit-api  $out/bin/sancho-submit-api
  '';
}
