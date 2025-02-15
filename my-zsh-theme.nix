{ stdenv, zsh-command-time }:

stdenv.mkDerivation rec {
  name = "my-theme";
  src = ./.;
  phases = [ "installPhase" ];
  installPhase = ''
    install -Dm0444 $src/themes/my-theme.zsh-theme $out/share/zsh/themes/my-theme.zsh-theme
  '';
}
