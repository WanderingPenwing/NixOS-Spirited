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
    rxvt-unicode-unwrapped
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
    brightnessctl # brightness settings
    micro
    xclip
    zip
    unzip
    maim
    xdotool
    starship # shell more pretty
    # Apps
    vivaldi
    qutebrowser
    discord
    gimp
    calcifer
    epiphany
    steam
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

  environment.variables.EDITOR = "urxvt";

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

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <${pkgs.writeText "Xresources" ''
      #define nord0 #222222
      #define nord1 #FF5555
      #define nord2 #5FD38D
      #define nord3 #FF9955
      #define nord4 #3771C8
      #define nord5 #BC5FD3
      #define nord6 #5FD3BC
      #define nord7 #999999
      #define nord8 #666666
      #define nord9 #FF8080
      #define nord10 #87DEAA
      #define nord11 #FFB380
      #define nord12 #5F8DD3
      #define nord13 #CD87DE
      #define nord14 #87DECD
      #define nord15 #CCCCCC

      *.foreground:   nord15
      *.background:   nord0
      *.cursorColor:  nord15
      *fading: 20
      *fadeColor: nord0

      *.color0: nord0
      *.color1: nord1
      *.color2: nord2
      *.color3: nord3
      *.color4: nord4
      *.color5: nord5
      *.color6: nord6
      *.color7: nord7
      *.color8: nord8
      *.color9: nord9
      *.color10: nord10
      *.color11: nord11
      *.color12: nord12
      *.color13: nord13
      *.color14: nord14
      *.color15: nord15

      ! URxvt Settings
      URxvt.font:     xft:DejaVu Sans Mono:size=13:antialias=true
      URxvt.boldFont: xft:DejaVu Sans Mono:bold:size=13:antialias=true
      urxvt*scrollBar:                  false
      urxvt*mouseWheelScrollPage:       true
      urxvt*cursorBlink:                true
      urxvt*saveLines:                  5000
      urxvt*internalBorder: 15
      urxvt*geometry: 90x90
      ! Setting transparency and background
       URxvt*depth:      32
       URxvt.background: [70]#222222

      ! Normal copy-paste keybindings  ( ctrl-shift c/v )
      urxvt.iso14755:                   false
      urxvt.keysym.Shift-Control-V:     eval:paste_clipboard
      urxvt.keysym.Shift-Control-C:     eval:selection_to_clipboard
      !xterm escape codes, word by word movement
      urxvt.keysym.Control-Left:        \033[1;5D
      urxvt.keysym.Shift-Control-Left:  \033[1;6D
      urxvt.keysym.Control-Right:       \033[1;5C
      urxvt.keysym.Shift-Control-Right: \033[1;6C
      urxvt.keysym.Control-Up:          \033[1;5A
      urxvt.keysym.Shift-Control-Up:    \033[1;6A
      urxvt.keysym.Control-Down:        \033[1;5B
      urxvt.keysym.Shift-Control-Down:  \033[1;6B
    ''}
  '';

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  #nix.settings.experimental-features = ["nix-command" "flakes"];
}
