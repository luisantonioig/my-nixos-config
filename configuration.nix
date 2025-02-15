# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let

  next = import <nixos-next> { config = { allowUnfree = true;};};
  unstable = import <nixos-unstable> { config = { allowUnfree = true;};};
  node = (pkgs.fetchFromGitHub 
                { 
                    owner = "IntersectMBO"; 
                    repo = "cardano-node"; 
                    rev= "30b6e447c7e4586f43e30a68fe47c8481b0ba205";
                    sha256= "sha256-DSvhXbm75rXMLgRCg/CLLeDFa6JbcCLTLJZoH/VY0MY=";
                });
  myHaskellEnv = pkgs.haskell.packages.ghc810;
  # flake-outputs = builtins.getFlake "github:aiken-lang/aiken/16fb02ee49879deb16ebacefa3b26ee5a57b7f8b";
  flake-outputs = builtins.getFlake "github:aiken-lang/aiken/22172069f891237d39379471477835c1fe54650f";
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    settings.substituters          = [ "https://cache.zw3rk.com" "https://cache.iog.io" ];
    settings.trusted-public-keys = [ "loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk=" "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
  '';
  systemd.services.nvidia-power = {
    description = "Configurar PowerMizer en NVIDIA";
    after = [ "multi-user.target" "display-manager.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = [
        "/run/wrappers/bin/sudo /run/current-system/sw/bin/nvidia-smi -pm 1"
        "/run/wrappers/bin/sudo /run/current-system/sw/bin/nvidia-smi -lgc 300,2100"
      ];
    };
  };
  # Bootloader.
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Mexico_City";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_MX.UTF-8";

  services.power-profiles-daemon.enable = false;
  services.tlp = {
  enable = true;
  settings = {
    # Configuración de umbrales de carga para la batería
    START_CHARGE_THRESH_BAT0 = 70;  # Comenzar carga cuando baje del 40%
    STOP_CHARGE_THRESH_BAT0 = 90;   # Detener carga al alcanzar el 80%
  };
};

  # services.ollama = {
  #   enable = true;
  #   acceleration = "cuda"; # Or "cuda"
  #   #};
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  services.xserver.videoDrivers = [ "nvidia" ];

  
  # Configure keymap in X11
  services.xserver = {
    layout = "es";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "es";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.emacs = {
    install = true;
    defaultEditor = true;
    enable = true;
    package = with pkgs; (
      (emacsPackagesFor emacs29).emacsWithPackages (
        epkgs: [
		      epkgs.use-package
          epkgs.typescript-mode
          epkgs.web-mode
          epkgs.lsp-mode
          epkgs.lsp-ui
          epkgs.company
          epkgs.yasnippet
          epkgs.tree-sitter
          epkgs.tree-sitter-langs
          epkgs.reformatter
          epkgs.magit

          
		      epkgs.nix-mode
          epkgs.haskell-mode
          epkgs.rust-mode
          
          epkgs.zenburn-theme
          epkgs.lsp-haskell
          epkgs.company-ghci
          epkgs.eglot
          epkgs.flycheck
          epkgs.flymake
          epkgs.flymake-eslint
          epkgs.diminish
          epkgs.shakespeare-mode
          
          (callPackage ./lambda-line.nix {
            inherit (pkgs) fetchFromGitHub;
            inherit (epkgs) trivialBuild all-the-icons;
          }) 
	      ]
      )
    );
  };
  
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.antonioi = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Antonio Ibarra";
    extraGroups = [ "vboxsf" "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };
  users.extraGroups.vboxusers.members = [ "antonioi" ];


  hardware.ledger.enable = true;
  services.trezord.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.sessionVariables = {
    __GL_SYNC_TO_VBLANK = "1";  # Sincronizar con VBlank
    __GL_ALLOW_INDIRECT = "1";
  };
  environment.systemPackages = with pkgs; [

    # unstable.ollama
    mednafen
    logiops
    # next.signal-desktop
    unetbootin
    woeusb
    parted
    ntfs3g
    kitty
    zsh
    # Programming in rust
    rustup
    cargo
    rust-analyzer
    gcc
    
    flake-outputs.packages.x86_64-linux.aiken
    # next.haskell.compiler.ghc9101
    # next.stylish-haskell
    # next.cabal-install
    # next.haskell-language-server
    # (next.haskell-language-server.overrideAttrs (old: {
    #   version = "2.9.0.1";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "haskell";
    #     repo = "haskell-language-server";
    #     rev = "2.9.0.1";
    #     sha256 = "1h6n0p5w75w1ckf710n6lzda76jnxz6z8j0bqyzwk24cxzrzhbf3"; # Cambia esto por el hash correcto
    #   };
    # }))
    
    nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server
    #  (pkgs.callPackage /home/antonioi/repo/financial-app/default.nix {})
    
    ocenaudio
    #  wget
    android-studio
    vscode
    docker
    git
    next.google-chrome
    # (pkgs.callPackage ./sancho.nix { })
    (pkgs.callPackage ./my_aiken.nix { })
    (pkgs.fetchFromGitHub 
                { 
                    owner = "IntersectMBO"; 
                    repo = "cardano-node"; 
                    rev= "30b6e447c7e4586f43e30a68fe47c8481b0ba205";
                    sha256= "sha256-DSvhXbm75rXMLgRCg/CLLeDFa6JbcCLTLJZoH/VY0MY=";
                })
    ledger-live-desktop
    trezor-suite
    wget
    unstable.slack
    telegram-desktop
    zoom-us
    spotify
    jq
    gimp
    discord
    (pkgs.callPackage ./image-viewer/default.nix {})
  ];
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      abrir = "emacs -nw";
    };
    ohMyZsh = {
      enable = true;
      plugins = ["git" "docker"];
      custom = "${pkgs.callPackage ./my-zsh-theme.nix { }}"; 
      theme = "agnoster";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
