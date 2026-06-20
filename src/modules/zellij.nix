{ config, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "fish";
      mouse_mode = true;
      session_serialization = false;
    };
  };

  programs.fish.interactiveShellInit = ''
    if set -q SSH_CONNECTION; and not set -q ZELLIJ
      zellij attach --create main
    end
  '';
}
