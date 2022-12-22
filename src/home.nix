{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim
    wget
    lxde.lxsession
    ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "abigailgooding";
  home.homeDirectory = "/home/abigailgooding";

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
  };
}
