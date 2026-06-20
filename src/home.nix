{ config, pkgs, ... }:

{
  imports = [
    ./modules/neovim.nix
    ./modules/zellij.nix
    ./claude/claude.nix
  ];

  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };
  home.packages = with pkgs; [
    # {{{ Sysadmin
    ripgrep
    wget
    ncdu # recursive file size finder
    navi
    just
    # }}}
    # {{{ OS/WM
    pavucontrol
    xclip # NOTE: middle click pastes previous selection, separate from clipboard
    manix # searches nix options
    # }}}
    # {{{ Development
    # searches for files based on their contents
    lazygit
    fish
    tmux
    alacritty
    mosh
    kitty
    # }}}
    # {{{ GUI tools
    obelisk
    google-chrome
    calibre
    pcmanfm
    # }}}
    # * Keyboard
    # qmk
    # qmk-udev-rules
    # qmk_hid
    # via
    # vial
    # * Unsorted
    lxsession
    polybar
    pasystray
    jq
    pdfstudioviewer
    cabal2nix
    nix-prefetch-git
    cabal-install
    ghc
    haskell-language-server
    vlc
    docker
    docker-compose
    lsof
    unzip
  ];

  # services.docker.enable = true;
  # services.docker.package = pkgs.docker;
  # containers.docker.enable = true;
  # containers.docker.compose.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "abigailgooding";
  home.homeDirectory = "/home/abigailgooding";
  home.keyboard.layout = "us";
  home.keyboard.variant = "dvorak";

  xresources.properties = {
    "Xft.dpi" = 120;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  services.udiskie = {
    enable = true;
    notify = false;
  };

  systemd.user.services.ibus-daemon = {
    Unit = {
      Description = "IBus input method daemon";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.ibus}/bin/ibus-daemon --replace";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    package = pkgs.gitFull;
    enable = true;
    settings = {
      user.name = "Abigail Gooding";
      user.email = "abigailalicegooding@gmail.com";
      core.editor = "nvim";
      status.showStash = true;
      merge.ff = "only";
    };
  };
  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      polybar = pkgs.polybar.override {
        i3Support = true;
      };
    };
  };
  # programs.nvim = {
  # enable = true;
  # defaultEditor = true;
  # };
}
