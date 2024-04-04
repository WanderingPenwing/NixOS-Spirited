{
  config,
  pkgs,
  options,
  ...
}: let
  where-is-my-sddm-theme = pkgs.callPackage ../apps/sddm/login_theme.nix {};
  calcifer = pkgs.callPackage ../apps/calcifer/install.nix {};
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
      configFile = ../apps/i3/config;
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
    #home-manager
    xfce.thunar # gui file manager
    rxvt-unicode-unwrapped
    bluez
    blueberry # bluetooth gui
    # CLIs
    acpi # battery status
    pamixer # sound settings
    brightnessctl # brightness settings
    maim # screenshot
    gawk # to format bash output
    starship # shell more pretty
    thefuck # correct mistakes
    git # code versioning
    alejandra # format code
    xclip # clipboard
    zip # compress files
    unzip # uncompress files
    xdotool
    btop # task manager
    ani-cli # watch anime
    micro # text editor
    ffmpeg # convert multimedia
    # Apps
    vivaldi
    qutebrowser
    gimp
    calcifer
    discord
    mpv # video player
    #arandr # check hdmi
    # Appearance
    feh # wallpaper
    yaru-theme
    papirus-icon-theme
    lxappearance
    i3blocks # status bar
    xborders # outline selected window
    betterlockscreen
    where-is-my-sddm-theme # custom import
  ];

  programs.noisetorch.enable = true;

  environment.variables = {
    EDITOR = "micro";
  };

  xdg.mime.defaultApplications = {
    "inode/directory" = "Thunar.desktop"; # This line sets Thunar as the default file manager
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
      corner-radius = 20;
    };
  };

  environment.interactiveShellInit = ''
    alias m="micro"
    alias c="clear"
    alias plz="sudo"
    alias moo="~/nixos/scripts/mount.sh"
    alias nix-dust="~/nixos/scripts/dust.sh"
    alias rebuild="~/nixos/scripts/rebuild.sh"
    alias edit="micro ~/nixos/system/configuration.nix"
    alias rust="cd ~/Documents/Projects/Rust/"
    alias python="cd  ~/Documents/Projects/Python/"
    alias lc="fc -nl -1 | xclip -selection clipboard"
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
    fi
    bind 'set show-all-if-ambiguous on'
    bind 'TAB:menu-complete'
    export STARSHIP_CONFIG=~/nixos/apps/urxvt/starship.toml
    eval "$(starship init bash)"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/github > /dev/null 2>&1
    trap 'ssh-agent -k' EXIT SIGHUP SIGINT SIGTERM
  '';

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
