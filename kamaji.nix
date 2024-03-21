{
  config,
  pkgs,
  options,
  ...
}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
  where-is-my-sddm-theme = pkgs.callPackage ./sddm/where-is-my-sddm-theme.nix {};
in {
  # Include the results of the hardware scan.
  imports = [(import "${home-manager}/nixos")];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;

    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";
    displayManager.sddm.enable = true;
    displayManager.sddm.theme = "where-is-my-sddm-theme";

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #app launcher commonly used
        i3status #default i3 status bar
        i3lock #default screen locker
      ];
    };

    layout = "fr";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
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

  # Define a user account. Don t forget to set a password with ‘passwd’.
  users.users.penwing = {
    isNormalUser = true;
    description = "Penwing";
    extraGroups = ["networkmanager" "wheel"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Utilities
    home-manager
    xfce.thunar
    sakura
    gnome.gnome-terminal
    bluez
    blueberry
    # CLIs
    git
    calc
    btop
    acpi
    gawk
    alejandra
    nix-index
    nix-prefetch
    ffmpeg
    pamixer
    micro
    xclip
    wine
    wine64
    winetricks
    legendary-gl
    # Apps
    vivaldi
    discord
    sublime
    gimp
    heroic
    lutris
    # Appearance
    feh
    picom
    yaru-theme
    papirus-icon-theme
    hack-font
    lxappearance
    i3blocks
    where-is-my-sddm-theme # custom import, coming from github
  ];

  nixpkgs.config = {
    sakura.conf = builtins.readFile ./apps/sakura.conf;
  };

  xdg.mime.defaultApplications = {
    "inode/directory" = "Thunar.desktop"; # This line sets Thunar as the default file manager
  };

  fonts.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
