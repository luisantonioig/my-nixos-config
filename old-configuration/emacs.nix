# Derivation for Emacs pre-configured with packages that I need.
#
# TODO: Fix sly (again)

{ pkgs }:

with pkgs; with emacs.pkgs;
let emacsWithPackages = (emacsPackagesFor emacs).emacsWithPackages;

# As the EXWM-README points out, XELB should be built from source if
# EXWM is.
xelb = melpaBuild {
  pname   = "xelb";
  ename   = "xelb";
  version = "0.15";
  recipe  = builtins.toFile "recipe" ''
    (xelb :fetcher github
          :repo "ch11ng/xelb")
  '';

  packageRequires = [ cl-generic emacs ];

  src = fetchFromGitHub {
    owner  = "ch11ng";
    repo   = "xelb";
    rev    = "b8f168b401977098fe2b30f4ca32629c0ab6eb83";
    sha256 = "1ack1h68x8ia0ji6wbhmayrakq35p5sgrrl6qvha3ns3pswc0pl9";
 };
};

# EXWM pinned to a newer version than what is released due to a
# potential fix for ch11ng/exwm#425.
exwm = melpaBuild {
  pname   = "exwm";
  ename   = "exwm";
  version = "0.19";
  recipe  = builtins.toFile "recipe" ''
    (exwm :fetcher github
          :repo "ch11ng/exwm")
  '';

  packageRequires = [ xelb ];

  src = fetchFromGitHub {
    owner  = "ch11ng";
    repo   = "exwm";
    rev    = "472f7cb82b67b98843f10c12e6bda9b8ae7262bc";
    sha256 = "19gflsrb19aijf2xcw7j2m658qad21nbwziw38s1h2jw66vhk8dj";
 };
};

slyFixed = sly.overrideAttrs(_: {
  recipe = builtins.toFile "recipe" ''
(sly :repo "joaotavora/sly"
     :fetcher github
     :files ("*.el"
             ("lib" "lib/*")
             ("contrib" "contrib/*")
             "doc/*.texi"
             "doc/*.info"
             "doc/dir"))
'';
});

in emacsWithPackages(epkgs:
  # Actual ELPA packages (the enlightened!)
  (with epkgs.elpaPackages; [
    ace-window
  ]) ++

  # MELPA packages:
  (with epkgs.melpaPackages; [
    browse-kill-ring
    nix-mode
    haskell-mode
    markdown-mode
    lsp-haskell
  ])

)
