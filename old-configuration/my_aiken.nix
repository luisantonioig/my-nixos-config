{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, stdenv ? pkgs.stdenv
, fetchurl ? pkgs.fetchurl
}:

stdenv.mkDerivation rec {
  name = "my-aiken";
  src = fetchurl {
    url = "https://github.com/aiken-lang/aiken/releases/download/v1.1.5/aiken-x86_64-unknown-linux-musl.tar.gz";
    sha256 = "sha256-B+ZROnMhqo9GvlwGUg7VMhx45suhI0Iw9E3UeGfyKqQ=";
  };
  installPhase = ''
    tar -xzf $src
    mkdir -p $out/bin
    cp aiken-x86_64-unknown-linux-musl/aiken $out/bin
  '';
}
