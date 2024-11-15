# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  pkgs-unstable,
  options,
  ...
}: let
  hostname = "kamaji"; # to alllow per-machine config
  calcifer = pkgs.callPackage ../apps/calcifer/install.nix {};
  ingary = pkgs.libsForQt5.callPackage ../apps/ingary/install.nix {};
  jiji = pkgs.callPackage ../apps/jiji/install.nix {};
  kodama = pkgs.callPackage ../apps/kodama/install.nix {};
  marukuru = pkgs.callPackage ../apps/marukuru/install.nix {};
  pendragon = pkgs.callPackage ../apps/pendragon/install.nix {};
  #savoia = pkgs.callPackage ../apps/savoia/install.nix {};
  susuwatari = pkgs.libsForQt5.callPackage ../apps/susuwatari/install.nix {};
  turnip = pkgs.callPackage ../apps/turnip/install.nix {};
  #zeniba = pkgs.callPackage ../apps/zeniba/install.nix {};
in {
  imports = [
    ./kamaji-hardware.nix
  ];
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostname;
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  services.displayManager = {
    defaultSession = "none+dwm";
    sddm.enable = true;
    sddm.package = pkgs.libsForQt5.sddm;
    sddm.theme = "ingary";
  };

  services.xserver = {
    enable = true;
	
    desktopManager.xterm.enable = false;

    windowManager.dwm = {
      package = pendragon;
      enable = true;
    };

    xkb.layout = "fr";
    xkb.variant = "";

    displayManager.sessionCommands = ''
      # Set wallpaper
      feh --bg-scale ~/nixos/wallpapers/main.png
      # start dunst with config
      ~/nixos/scripts/notif_restart.sh &
      # start status bar
      turnip &
      # start clipboard
      susuwatari &
    '';
  };

  # Round corners
  services.picom = {
    enable = true;
    package = pkgs.picom-next;
    settings = {
      vsync = true;
      backend = "glx";
      corner-radius = 20;
      rounded-corners-exclude = [
        "window_type = 'dock'"  # Exclude windows of type 'dock'
        "class_g = 'dwm'"       # Or exclude windows with class 'dwm' 
        "class_g = 'dmenu'"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = (with pkgs; [
    # Libs
    libnotify
    jdk21
    
    # CLIs
    pamixer # sound settings
    brightnessctl # brightness settings
    maim # screenshot
    xclip # clipboard
    xdotool # add keyboard automation
    dunst # send notifications
    inotify-tools # file events
    texlive.combined.scheme-full #tex
    
    # Custom Apps
    calcifer # code editor
    ingary # sddm theme
    jiji # discord lite
    kodama # terminal
    marukuru # app menu
    pendragon # windows manager
   	susuwatari # clipboard
   	turnip # status bar
   	
   	# Other Apps
   	discord
    mpv # video player
    torrential
    zathura
    hmcl # minecraft
    obsidian 
    godot_4
    playonlinux
    
    # Appearance
    feh # wallpaper
    yaru-theme
    papirus-icon-theme
    lxappearance
  ]) ++ (with pkgs-unstable; [
    ungoogled-chromium
  ]);

  programs.noisetorch.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  xdg.mime.defaultApplications = {
  	"image/png" = "zeniba.desktop";
  	"image/jpeg" = "zeniba.desktop";
  	"image/jpg" = "zeniba.desktop";
  	"image/webp" = "zeniba.desktop";
  	"image/gif" = "zeniba.desktop";
  	"image/svg+xml" = "zeniba.desktop";
  	"application/pdf" = "zathura.desktop";
  };

  # Gaming setup
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  programs.gamemode.enable = true;

  services.mullvad-vpn.enable = true;

  virtualisation.docker.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; #to compile raspberry pi

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
