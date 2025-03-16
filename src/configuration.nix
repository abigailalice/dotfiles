# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # nix.registry.nixpkgs.flake = nixpkgs;
  imports = [];

  services.ollama = {
    enable = true;
    # loadModels = [ ... ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # boot.supportedFilesystems = [ "ntfs" ];

  # these avoid the need for these two commands:
  # "nix-store --optimize" and "nix-collect-garbage"
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 8d";
  nix.settings.auto-optimise-store = true;

  programs.fish.enable = true;

  # {{{ docker
  # virtualisation.docker.extraOptions = "--userns-remap=default";
  # users.groups.dockremap.gid = 10000;
  #
  # users.users = {
  #   dockremap = {
  #     isSystemUser = true;
  #     uid = 1000;
  #     group = "dockremap";
  #     subUidRanges = [
  #       { startUid = 1000; count = 65536; }
  #     ];
  #     subGidRanges = [
  #       { startGid = 100; count = 65536; }
  #     ];
  #   };
  # };
  # }}}

  services.cron = {
    enable = true;
    systemCronJobs = [
      "* 0 * * * docker system prune -a"
    ];
  };

  # this specifies the local network name, accessable via smb://<hostName>.local
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # {{{ https://functor.tokyo/blog/2018-10-01-japanese-on-nixos
  # enable by running "ibus-daemon -d"
  # configure with "ibus-setup"
  systemd.services.ibus-startup = {
    description = "Starts ibus daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "{$pkgs.bash}/bin/bash -c 'ibus-daemon -d'";
      Type = "simple";
      User = "abigailgooding";
      WorkingDirectory = "/home/abigailgooding";
    };
  };

  fonts = {
    packages = with pkgs; [
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
  # debug with fcitx5-configtool
  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.engines = with pkgs.fcitx-engines; [ mozc ];
  #   fcitx5.addons = with pkgs; [
  #     fcitx5-mozc
  #     fcitx5-gtk
  #   ];
  # };

  # debug with ibus-setup
  # mozc seems to work better
  i18n.inputMethod = {
    # enabled = "ibus";
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      anthy
      mozc
      rime
    ];
  };
  # https://www.reddit.com/r/NixOS/comments/rezf0s/how_to_run_script_on_startup/
  systemd.user.services.ibus = {
    description = "ibus startup script";
    serviceConfig.PassEnvironment = "DISPLAY";
    script = "ibus-daemon -d";
    wantedBy = [ "multi-user.target" ];
  };

  # }}}

  # {{{ file sharing
  # setup "sudo smbpasswd -a <user>" to add a user. the user must already exist
  # in the unix system, this just adds it to sambda
  # the path specified in services.samba.shares.<share>.path should already be
  # created, and setup with
  #   sudo chown <username>:<group> /path/to/share
  #   sudo chmod 775 /path/to/share
  # Use "ip addr show | grep inet" to find the ip address
  # Connect to "smb://<ip>/<share?

  services = {
    # Network shares
    # samba = {
    #   package = pkgs.samba4Full;
    #   # ^^ `samba4Full` is compiled with avahi, ldap, AD etc support (compared to the default package, `samba`
    #   # Required for samba to register mDNS records for auto discovery 
    #   # See https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/pkgs/top-level/all-packages.nix#L27268
    #   enable = true;
    #   openFirewall = true;
    #   # smb://<ip>/<share> is the name of the server
    #   shares.share = {
    #     path = "/mount/share";
    #     writable = "true";
    #     comment = "Hello World!";
    #   };
    #   settings = {
    #     "server smb encrypt" = "required";
    #     "server min protocol" = "SMB3_00";
    #   };
    #   # extraConfig = ''
    #   #   server smb encrypt = required
    #   #   # ^^ Note: Breaks `smbclient -L <ip/host> -U%` by default, might require the client to set `client min protocol`?
    #   #   server min protocol = SMB3_00
    #   # '';
    # };
    avahi = {
      publish.enable = true;
      publish.userServices = true;
      # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
      #nssmdns4 = true;
      # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
      enable = true;
      openFirewall = true;
      nssmdns4 = true;
    };
  };

  # }}}

  # {{{ external hdds
  # You can get the information you need to fill in new entries with
  # $ sudo blkid
  # $ lsblk -o NAME,MOUNTPOINT,SIZE,MODEL
  fileSystems = {
    "/media/scidb" = {
      device = "/dev/disk/by-uuid/3E64D4A100914BC7";
      fsType = "ntfs";
      options = [ "defaults" "noatime" "nofail" ];
    };
    "/media/fast" = {
      device = "/dev/disk/by-uuid/00AEBB49AEBB364E";
      fsType = "ntfs";
      options = [ "defaults" "noatime" "nofail" ];
    };
    "/media/calibre" = {
      device = "/dev/disk/by-uuid/8c77febe-35f1-45ca-b134-fda28feba88e";
      fsType = "ext4";
      options = [ "defaults" "noatime" "nofail" ];
    };
  };
  # }}}

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = false;
  hardware.enableAllFirmware = true;

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true;
  #   dedicatedServer.openFirewall = true;
  # };

  programs.dconf.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  environment.pathsToLink = [ "/libexec" ];

  # https://github.com/obsidiansystems/obelisk
  nix.settings.substituters = [
    "https://nixcache.reflex-frp.org"
    "https://rel8.cachix.org"
    "https://cache.iog.io"
  ];
  nix.settings.trusted-public-keys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
  # https://github.com/obsidiansystems/obelisk/issues/1010
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # enable support for bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  systemd.services.my-startup-script = {
    description = "Run my startup script";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "{$pkgs.bash}/bin/bash -c 'rm ~/.config/obsidian-1.5.12.asar'";
      Type = "simple";
      User = "abigailgooding";
      WorkingDirectory = "/home/abigailgooding";
    };

    };

  services.openssh = {
    ports = [9272];
    enable = true;
    settings.PasswordAuthentication = false;
    settings.X11Forwarding = true;
  };
  # users.users.abigailgooding.openssh.authorizedKeys.keys = ["PUBLIC KEY STRING"];

  # Configure keymap in X11
  # one of these options, but not both
  console.useXkbConfig = true;
  # console.keyMap = "us";
  services.displayManager.defaultSession = "none+i3";
  services.xserver = {
    xkb.layout = "us";
    # xkbVariant = "dvorak";
    # xkbOptions = "grp:caps_toggle,grp_led:caps";
    enable = true;

    desktopManager = {
      xterm.enable = false;
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
    packages = with pkgs; [
      fish
      obsidian
    ];
    shell = pkgs.fish;
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
     eza
     fd
     git
     gh
     nixos-option
     termite
     alacritty
     xcwd
     xfce.thunar
     polybar
     zathura
     libsecret
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
