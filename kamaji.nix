{
  config,
  pkgs,
  options,
  ...
}: let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
  where-is-my-sddm-theme = pkgs.callPackage ./apps/sddm/where-is-my-sddm-theme.nix {};
  calcifer = pkgs.callPackage ./apps/calcifer/install.nix {};
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
      package = pkgs.i3-gaps;
      enable = true;

      # extraPackages = with pkgs; [
      #   dmenu #app launcher commonly used
      #   i3status #default i3 status bar
      #   i3lock #default screen locker
      # ];
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
    bluez
    blueberry
    # CLIs
    git
    btop
    acpi
    gawk
    alejandra # format code
    ffmpeg # convert multimedia
    pamixer # sound settings
    micro
    xclip
    zip
    unzip
    maim
    xdotool
    starship # shell more pretty
    # Apps
    vivaldi
    discord
    gimp
    calcifer
    #epiphany
    mpv
    #arandr # check hdmi
    # Appearance
    feh
    yaru-theme
    papirus-icon-theme
    lxappearance
    i3blocks
    xborders
    where-is-my-sddm-theme # custom import, coming from github
  ];

  home-manager.users.penwing = {
    home.stateVersion = "18.09";

    programs.git = {
      enable = true;
      userName = "WanderingPenwing";
      userEmail = "nicolas.pinson31@gmail.com";
    };

    #programs.picom.settings = builtins.readFile ./apps/picom.conf;

    #home.file.".config/sakura/sakura.conf".source = ./apps/sakura.conf;
    #home.file.".config/i3/config".source = ./apps/i3.conf;
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

  services.picom = {
    enable = true;
    package = pkgs.picom-next;
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  #nix.settings.experimental-features = ["nix-command" "flakes"];
}
