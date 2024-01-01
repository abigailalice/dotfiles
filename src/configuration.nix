# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # {{{ https://functor.tokyo/blog/2018-10-01-japanese-on-nixos
  # enable by running "ibus-daemon -d"
  # configure with "ibus-setup"

  fonts = {
    fonts = with pkgs; [
      carlito
      dejavu_fonts
      ipafont
      kochi-substitute
      source-code-pro
      ttf_bitstream_vera
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [
          "DejaVu Sans Mono"
          "IPAGothic"
        ];
        sansSerif = [
          "DejaVu Sans"
          "IPAPGothic"
        ];
        serif = [
          "DejaVu Serif"
          "IPAPMincho"
        ];
      };
    };
  };
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n.inputMethod.enabled = "ibus";
  i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [
    anthy
    mozc
  ];
  # }}}

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";


  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;
  hardware.enableAllFirmware = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  environment.pathsToLink = [ "/libexec" ];

  # https://github.com/obsidiansystems/obelisk
  nix.settings.substituters = [ "https://nixcache.reflex-frp.org" ];
  nix.settings.trusted-public-keys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
  # https://github.com/obsidiansystems/obelisk/issues/1010
  nix.settings.experimental-features = [ "nix-command" ];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        i3lock
        i3blocks
     ];
    };
  };


  services.udev.extraRules = ''
    ACTION=-"add", SUBSYSTEM=="block", RUN+="${pkgs.bash}/bin/bash -c '${pkgs.pmount}/bin/pmount --sync --umask 000 %N &>> /tmp/udev-pmount.log'
    '';
      

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.abigailgooding = {
    isNormalUser = true;
    description = "Abigail Gooding";
    extraGroups = [ "networkmanager" "wheel" "kvm" "libvirtd" "docker"];
    packages = with pkgs; [];
  };
  virtualisation.docker.enable = true;
  # /etc/group
  # docker:x:131:<username>

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     neovim
     flashfocus
     rofi
     picom
     firefox
     home-manager
     exa
     fd
     git
     gh
     nixos-option
     termite
     xcwd
     xfce.thunar
     polybar
  ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  security.sudo.wheelNeedsPassword = false;
  services.devmon.enable = true;

  environment.shellAliases = {
    ls = "exa -la";
    rm = "rm -i";
    cp = "cp -i";
    mkdir = "mkdir -p";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
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
  services.picom = {
    enable = true;
    settings = {
      detect-client-opacity = true;
      inactive-dim = 0.4;
      opacity-rule = [
        "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      ];
    };
  };

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
  system.stateVersion = "22.11"; # Did you read the comment?

}
