{ config, pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "fish";
      mouse_mode = true;
      session_serialization = false;
    };
    extraConfig = ''
      keybinds clear-defaults=false {
          pane {
              bind "r" { SwitchToMode "RenamePane"; PaneNameInput 0; }
              bind "\\" { NewPane "Right"; SwitchToMode "Normal"; }
              bind "-" { NewPane "Down"; SwitchToMode "Normal"; }
          }
      }
    '';
  };

  programs.fish.interactiveShellInit = ''
    if set -q SSH_CONNECTION; and not set -q ZELLIJ
      zellij attach --create main
    end
  '';
}
