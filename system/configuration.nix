{
  config,
  pkgs,
  options,
  ...
}: let
  ghibli-sddm-theme = pkgs.libsForQt5.callPackage ../apps/sddm/login_theme.nix {};
  calcifer = pkgs.callPackage ../apps/calcifer/install.nix {};
  jiji = pkgs.callPackage ../apps/jiji/install.nix {};
  urxvtConfig = import ../apps/urxvt/config.nix;
in {
  # Include the results of the hardware scan.
  imports = [
    urxvtConfig
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # ntfs support
  boot.supportedFilesystems = ["ntfs"];

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

  services.displayManager = {
    defaultSession = "none+i3";
    sddm.enable = true;
    sddm.package = pkgs.libsForQt5.sddm;
    sddm.theme = "ghibli-sddm-theme";
  };

  services.xserver = {
    enable = true;

    desktopManager.xterm.enable = false;

    windowManager.i3 = {
      package = pkgs.i3-gaps;
      enable = true;
      configFile = ../apps/i3/config;
    };

    xkb.layout = "fr";
    xkb.variant = "";
  };

  # vpn
  services.mullvad-vpn.enable = true;

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
    # Libs
    jdk21
    libnotify
    # CLIs
    acpi # battery status
    pamixer # sound settings
    brightnessctl # brightness settings
    maim # screenshot
    gawk # to format bash output
    starship # shell more pretty
    git # code versioning
    alejandra # format code
    xclip # clipboard
    xdotool # fake keyboard/mouse
    btop # task manager
    ani-cli # watch anime
    micro # text editor
    # ffmpeg # convert multimedia
    nnn # file manager
    dunst # send notifications
    # parted # handle usb partitions
    zip
    unzip
    calc
    # Apps
    rxvt-unicode-unwrapped # my terminal
    ungoogled-chromium
    qutebrowser
    luakit
    gimp
    calcifer
    jiji
    discord
    mpv # video player
    prismlauncher
    jellyfin-media-player
    pavucontrol
    blockbench-electron
    torrential
    # Appearance
    feh # wallpaper
    yaru-theme
    papirus-icon-theme
    lxappearance
    i3blocks # status bar
    xborders # outline selected window
    betterlockscreen
    ghibli-sddm-theme
  ];

  programs.noisetorch.enable = true;

  #   programs.steam = {
  #     enable = true;
  #     gamescopeSession.enable = true;
  #     remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #     dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #   };
  #
  #   programs.gamemode.enable = true;

  environment.variables = {
    EDITOR = "micro";
  };

  fonts.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    (nerdfonts.override {fonts = ["Hermit" "FiraCode" "Mononoki" "ComicShannsMono"];})
  ];

  services.picom = {
    enable = true;
    package = pkgs.picom-next;
    settings = {
      vsync = true;
      backend = "glx";
      corner-radius = 20;
    };
  };

  environment.interactiveShellInit = ''
    if [ -f $HOME/nixos/scripts/.shell_config ]; then
        . $HOME/nixos/scripts/.shell_config
    else
        echo "error shell loading config"
    fi
  '';

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
