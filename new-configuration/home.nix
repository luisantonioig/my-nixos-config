{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "antonio";
  home.homeDirectory = "/home/antonio";


  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.



  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs: [
      epkgs.magit
	    epkgs.company
	    epkgs.company-quickhelp
	    epkgs.treesit-grammars.with-all-grammars
	    epkgs.nix-mode
      epkgs.haskell-mode
      epkgs.lsp-haskell
      epkgs.lsp-mode
      epkgs.lsp-ui
	    epkgs.json-mode
      epkgs.consult
      epkgs.beacon
      epkgs.doom-modeline
      epkgs.nerd-icons
      epkgs.dashboard
    ];
  };

  programs.bash ={
    enable = true;
      initExtra = ''
    # Configuración de colores ANSI para que coincidan con Elegant Black
    export PS1="\[\e[38;5;250m\]\u\[\e[0m\]@\[\e[38;5;68m\]\h:\[\e[38;5;107m\]\w\[\e[0m\]$ "
    
    # Colores del tema elegant-black en el prompt
    export LS_COLORS="di=1;34:ln=1;36:so=35:pi=33:ex=32"

    # Cambiar colores del texto en terminal
    echo -e '\e]10;#DCDCCC\a'  # Texto principal
    echo -e '\e]11;#1E1E1E\a'  # Fondo
    echo -e '\e]12;#FFCC66\a'  # Cursor

    # Configurar tipo de cursor (barra normal y gruesa cuando escribes)
    echo -e '\e[5 q'  # Barra normal

    if [ "$TERM" = "xterm-kitty" ]; then
      unset PROMPT_COMMAND
    fi
    '';
  };

  programs.kitty = {
  enable = true;
  settings = {
    # Fondo y transparencia
    background = "#1E1E1E";
    background_opacity = "0.90";  # Ajusta entre 0.0 (transparente) y 1.0 (opaco)

    # Colores del tema Elegant Black
    foreground = "#DCDCCC"; # Texto principal
    cursor = "#FFCC66";     # Cursor amarillo
    selection_foreground = "#DCDCCC";
    selection_background = "#3A3A3A";
    url_color = "#66CCCC";

    # Definición de colores ANSI
    color0  = "#1E1E1E"; # Negro
    color1  = "#F2777A"; # Rojo
    color2  = "#99CC99"; # Verde
    color3  = "#FFCC66"; # Amarillo
    color4  = "#6699CC"; # Azul
    color5  = "#CC99CC"; # Magenta
    color6  = "#66CCCC"; # Cian
    color7  = "#DCDCCC"; # Blanco/gris claro

    color8  = "#7F7F7F"; # Gris oscuro
    color9  = "#F2777A"; # Rojo brillante
    color10 = "#99CC99"; # Verde brillante
    color11 = "#FFCC66"; # Amarillo brillante
    color12 = "#6699CC"; # Azul brillante
    color13 = "#CC99CC"; # Magenta brillante
    color14 = "#66CCCC"; # Cian brillante
    color15 = "#FFFFFF"; # Blanco brillante

    # Fuente y tamaño de texto
    font_family = "IBM Plex Mono";
    font_size = 12;

    # Cursor como en Emacs (barra en lugar de bloque)
    cursor_shape = "beam";
    cursor_blink_interval = 0;
    
    # Color de subrayado como en Emacs
    underline_color = "#FFCC66";

    # Bordes y márgenes
    window_padding_width = 8;
    inactive_text_alpha = 0.8;
  };
};

  
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    xmobar
    feh


    slack
    google-chrome
    # rofi-wayland
    # (waybar. overrydeAttrs (oldAtts: {
    #   mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    # }))
    # dunts
    # libnotify
    
    ibm-plex
    ripgrep
    nodejs_23

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };



  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/antonio/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    PS1 = "\\[\\e[38;5;214m\\]\\u\\[\\e[0m\\]@\\[\\e[38;5;33m\\]\\h:\\[\\e[38;5;40m\\]\\w\\[\\e[0m\\]$ ";
    LS_COLORS = "di=1;34:ln=36:so=35:pi=33:ex=32";
    
    
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBGL_ALWAYS_INDIRECT = "1";

    # EDITOR = "emacs";
  };

  # xsession.enable = true;
  # xsession.windowManager.command = lib.mkForce "xmonad";

  # xsession.windowManager.xmonad = {
  #   enable = true;
  #   haskellPackages = pkgs.haskellPackages;
  #   enableContribAndExtras = true;

  #   extraPackages = self: with self; [
  #     xmonad-contrib
  #     xmonad-extras
  #   ];

  #   config = pkgs.writeText "xmonad.hs" ''
  #     import XMonad
  #     import XMonad.Util.EZConfig (additionalKeys)
  #     import XMonad.Hooks.DynamicLog
  #     import XMonad.Hooks.ManageDocks
  #     import System.Exit (exitWith, ExitCode(ExitSuccess))

  #     main = xmonad =<< statusBar "xmobar" myXmobarPP toggleStrutsKey myConfig

  #     myConfig = def
  #       { terminal = "kitty"
  #       , modMask = mod4Mask
  #       , borderWidth = 2
  #       , layoutHook = avoidStruts $ layoutHook def
  #       , manageHook = manageDocks <+> manageHook def
  #       }

  #     myXmobarPP = xmobarPP { ppTitle = xmobarColor "green" "" . shorten 50 }

  #     toggleStrutsKey XConfig {modMask = modm} = (modm, xK_b)
  #   '';

  #   libFiles = {
  #     "MyLayout.hs" = pkgs.writeText "MyLayout.hs" ''
  #       module MyLayout where
  #       import XMonad
  #       myLayout = Tall 1 (3/100) (1/2)
  #     '';
  #   };
  # };

  wayland.windowManager.hyprland = {
    settings = {
      animations = {
        enabled = false;
      };
      input = {
        kb_layout = "latam";
        follow_mouse = 0;
      };
      # monitor = [
      #   "HDMI-1,2560x1080@60,0x0,1"  # Monitor principal, a la izquierda
      #   "None-1,2560x1600@60,2560x0,1"  # Secundario, alineado a la derecha
      # ];
      "plugin:hyprland-aquamarine" = {
        enabled = false;
      };
      
      bind = [
        "SUPER, Return, exec, kitty"
      # ];
      # bind = [
        # "SUPER+Left, windowfocus left"
        # "SUPER+Right, windowfocus right"
        # "SUPER+Up, windowfocus up"
        # "SUPER+Down, windowfocus down"
      ];
      input.bind = [
        
      
      ];
    };
    extraConfig = ''
      bind = SUPER, h, movefocus, l
      bind = SUPER, l, movefocus, r
      bind = SUPER, k, movefocus, u
      bind = SUPER, j, movefocus, d
    '';
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
