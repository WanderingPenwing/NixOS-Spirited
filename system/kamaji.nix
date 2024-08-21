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
  savoia = pkgs.callPackage ../apps/savoia/install.nix {};
  susuwatari = pkgs.libsForQt5.callPackage ../apps/susuwatari/install.nix {};
  turnip = pkgs.callPackage ../apps/turnip/install.nix {};
  zeniba = pkgs.callPackage ../apps/zeniba/install.nix {};
in {
  imports = [
    ./kamaji-hardware.nix
  ];

  networking.hostName = hostname;
  networking.nameservers = ["192.168.1.42" "8.8.8.8" "8.8.4.4" ];

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
  
    # Libs
    libnotify
    
    # CLIs
    pamixer # sound settings
    brightnessctl # brightness settings
    maim # screenshot
    xclip # clipboard
    xdotool # add keyboard automation
    dunst # send notifications
    bc # calculator
    
    # Custom Apps
    calcifer # code editor
    ingary # sddm theme
    jiji # discord lite
    kodama # terminal
    marukuru # app menu
    pendragon # windows manager
    savoia # browser
   	susuwatari # clipboard
   	turnip # status bar
   	zeniba # image viewer
   	
   	# Other Apps
   	discord
   	quickemu
    surf
    mpv # video player
    torrential
	gimp
    seafile-client
    zathura
    
    # Appearance
    feh # wallpaper
    yaru-theme
    papirus-icon-theme
    lxappearance
  ]) ++ (with pkgs-unstable; [
    ungoogled-chromium
  ]);

  programs.noisetorch.enable = true;

  xdg.mime.defaultApplications = {
  	"image/png" = "zeniba.desktop";
  	"image/jpeg" = "zeniba.desktop";
  	"image/jpg" = "zeniba.desktop";
  	"image/webp" = "zeniba.desktop";
  	"image/gif" = "zeniba.desktop";
  	"image/svg+xml" = "zeniba.desktop";
  };

  #   programs.steam = {
  #     enable = true;
  #     gamescopeSession.enable = true;
  #     remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #     dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #   };
  #
  #   programs.gamemode.enable = true;

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

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
