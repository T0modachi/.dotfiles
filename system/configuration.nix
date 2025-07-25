# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # JVV nix flakes following https://www.youtube.com/watch?v=mJbQ--iBc1U&t=2s
  nix.package = pkgs.nixVersions.latest;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nix.settings = {
    trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="];
    substituters = ["https://devenv.cachix.org"];
    trusted-users = ["root" "T0modachi" "jvergara-ialink"];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Santiago";
  #time.timeZone = "Europe/Madrid";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_CL.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };

  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "la-latin1";
  #  useXkbConfig = true; # use xkbOptions in tty.
  #};

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];

  services.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma6.enable = true;
  services.desktopManager.plasma6.enable = true;

  # hyprland
  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };
  #wayland support for electron based apps and chromium
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-wlr
    ];
    xdgOpenUsePortal = true;
  };

  environment.sessionVariables.HSA_XNACK = "1";

  environment.sessionVariables.TERM = "xterm-256color";

  # jvv: incluyo soporte ntfs para montar pendrive
  boot.supportedFilesystems = ["ntfs"];

  #jvv: para limitar el maximo de generaciones en boot
  boot.loader.systemd-boot.configurationLimit = 5;

  # jvv: para instalar paquetes unfree
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "latam";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  services.ollama = {
    enable = true;
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.T0modachi = {
    isNormalUser = true;
    initialPassword = "passwd";
    extraGroups = ["wheel" "docker" "plugdev" "networkmanager"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  users.users.jvergara-ialink = {
    isNormalUser = true;
    initialPassword = "passwd";
    extraGroups = ["wheel" "docker" "plugdev" "networkmanager"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # nixpkgs.overlays = [
  #   (
  #     final: prev: {
  #       logseq = prev.logseq.override {
  #         electron = prev.electron_27;
  #       };
  #     }
  #   )
  # ];
  # nixpkgs.config.permittedInsecurePackages = [
  #   "electron-27.3.11"
  # ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    home-manager # jvv: incluyo segun instrucciones de https://www.youtube.com/watch?v=FcC2dzecovw
    gcc
    rustc
    cargo
    lua
    git
    git-crypt
    gnupg
    (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {})
    libsForQt5.kdeconnect-kde
    gnumake
    docker-compose
    kitty
    ollama
    unzip
    unrar
    ripgrep
    fzf
    fd
    starship
    lazygit
    sesh
    zoxide
    xclip
    wl-clipboard
    jq
    kdePackages.kcalc
    kdePackages.xwaylandvideobridge
    #aider-chat
    #pharo
    steam-run
    glamoroustoolkit
    #logseq
    heaptrack
    discord
    awscli2
    vlc
    keymapp
    zellij
    ghostty
    bitwarden-cli
    gemini-cli
  ];

  #fonts.packages = with pkgs; [nerd-fonts];
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  programs.nix-ld.enable = true;

  # Sets up all the libraries to load
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    zlib
    nss
    openssl
    curl
    expat
    glibc
    #steam-run.fhsenv.args.multiPkgs
  ];

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

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };

  # Syncthing ports
  networking.firewall.allowedTCPPorts = [8384 22000];
  networking.firewall.allowedUDPPorts = [22000 21027];

  services = {
    syncthing = {
      enable = true;
      user = "T0modachi";
      dataDir = "/home/T0modachi/Sync"; # Default folder for new synced folders
      configDir = "/home/T0modachi/.config/syncthing"; # Folder for Syncthing's settings and keys
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # storage optimizations

  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # virtualbox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["jvergara-ialink"];
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;
}
