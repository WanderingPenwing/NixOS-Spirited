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
	matui = pkgs.callPackage ../apps/matui/install.nix {};
in {
	imports = [
		./kamaji-hardware.nix
	];

	hardware.bluetooth.enable = true;

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.initrd.kernelModules = [ "amdgpu" ];

	networking.hostName = hostname;
	networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

	services.displayManager.defaultSession = "none+dwm";
	services.displayManager.sddm = {
		enable = true;
		package = pkgs.libsForQt5.sddm;
		theme = "ingary";
		settings = {
			General = {
				InputMethod = "";
			};
			X11 = {
				KeyboardLayout = "us";
				KeyboardVariant = "";
			};
		};
	};

	services.xserver = {
		enable = true;

		videoDrivers = [ "amdgpu" ];
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
			# start picom
			picom --config ~/nixos/apps/picom/picom.conf &
		'';
	};

	virtualisation.docker.enable = true;

	# Round corners
	services.picom = {
		enable = false;
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
		tealdeer # tldr man
		ani-cli
		picom-pijulius
		matui

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
		godot_4
		gimp
		blender
		audacity
		librewolf
		chromium

		# Appearance
		feh # wallpaper
		yaru-theme
		papirus-icon-theme
		lxappearance
	]);

	nixpkgs.config.permittedInsecurePackages = [
		"olm-3.2.16"
	];

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
	system.stateVersion = "25.05"; # Did you read the comment?
}
