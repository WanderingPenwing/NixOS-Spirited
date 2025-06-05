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
	jenkins = pkgs.callPackage ../apps/jenkins/install.nix {};
	susuwatari = pkgs.libsForQt5.callPackage ../apps/susuwatari/install.nix {};
	turnip = pkgs.callPackage ../apps/turnip/install.nix {};
	zeniba = pkgs.callPackage ../apps/zeniba/install.nix {};
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

		videoDrivers = [ "amdgpu" ];
		deviceSection = ''
			Option "DRI" "3"
			Option "PixmapCacheSize" "512"
		'';
		desktopManager.xterm.enable = false;

		windowManager.dwm = {
			package = jenkins;
			enable = true;
		};

		xkb.layout = "us";
		xkb.variant = "";
		xkb.options = "compose:ralt,caps:escape";

		displayManager.sessionCommands = ''
			# Initialize DBus session
			eval "$(dbus-launch --sh-syntax --exit-with-session)"
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
		package = pkgs.picom-pijulius;#:pkgs.picom-next; 
		settings = {
			vsync = true;
			backend = "glx";
			corner-radius = 20;
			rounded-corners-exclude = [
				"window_type = 'dock'"  # Exclude windows of type 'dock'
				"class_g = 'dwm'"       # Or exclude windows with class 'dwm' 
				"class_g = 'dmenu'"
			];
			# fade = true;
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
		#texlive.combined.scheme-full #tex
		tealdeer # tldr man
		ani-cli

		# Custom Apps
		calcifer # code editor
		ingary # sddm theme
		jiji # discord lite
		kodama # terminal
		marukuru # app menu
		jenkins # windows manager
		susuwatari # clipboard
		turnip # status bar
		zeniba # image viewer

		# Other Apps
		discord
		mpv # video player
		torrential
		zathura
		hmcl # minecraft
		modrinth-app
		godot_4
		gimp
		blender
		qutebrowser
		easyeffects

		# Appearance
		feh # wallpaper
		yaru-theme
		papirus-icon-theme
		lxappearance
	]);

	documentation = {
		dev.enable = true;
		man.generateCaches = true;
		nixos.includeAllModules = true;
	};

	# Enable sound with pipewire.
	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	# configuration system
	services.dbus.packages = [ pkgs.dconf ];

	# Gaming setup
	programs.steam = {
		enable = true;
		gamescopeSession.enable = true;
		remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	};
	programs.gamemode.enable = true;

	services.mullvad-vpn.enable = true;

	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment?
}
