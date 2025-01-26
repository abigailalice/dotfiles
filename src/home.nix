{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  nixpkgs.config = {allowUnfree = true;};
  home.packages = with pkgs; [
    # {{{ Sysadmin
    ripgrep
    wget
    ncdu # recursive file size finder
    # }}}
    # {{{ OS/WM
    pavucontrol
    xclip # NOTE: middle click pastes previous selection, separate from clipboard
    manix # searches nix options
    # }}}
    # {{{ Development
    # searches for files based on their contents
    neovim
    lazygit
    fish
    tmux
    alacritty
    # }}}
    # {{{ GUI tools
    obelisk
    opera
    google-chrome
    calibre
    pcmanfm
    # }}}
    # * Unsorted
    lxde.lxsession
    polybar
    pasystray
    jq
    direnv
    nix-direnv
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

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Abigail Gooding";
    userEmail = "abigailalicegooding@gmail.com";
    extraConfig = {
      core = {
        editor = "nvim";
      };
      status = {
        showStash = true;
      };
    };
  };
  nixpkgs.config = {
    packageOverrides = pkgs: rec {
      polybar = pkgs.polybar.override {
        i3Support = true;
      };
    };
  };
  /* programs.nvim = { */
  /*   enable = true; */
  /*   defaultEditor = true; */
  /* }; */
}
