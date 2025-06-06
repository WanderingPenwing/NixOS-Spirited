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
		vSync = true;
		backend = "glx";
		settings = {
			animations = true;
			animation-stiffness = 300.0;
			animation-dampening = 35.0;
			animation-clamping = false;
			animation-mass = 1;
			animation-for-workspace-switch-in = "auto";
			animation-for-workspace-switch-out = "auto";
			animation-for-open-window = "slide-down";
			animation-for-menu-window = "none";
			animation-for-transient-window = "slide-down";
			corner-radius = 20;
			rounded-corners-exclude = [
				"window_type = 'dock'"  # Exclude windows of type 'dock'
				"class_g = 'dwm'"       # Or exclude windows with class 'dwm' 
				"class_g = 'dmenu'"
			];
			# rules = [
			# 	{
			# 		match = "window_type = 'normal'";
			# 		animations = [
			# 			{
			# 				triggers = ["close"];
			# 				opacity = {
			# 					curve = "cubic-bezier(0,1,1,1)";
			# 					duration = 0.3;
			# 					start = "window-raw-opacity-before";
			# 					end = 0;
			# 				};
			# 				blur-opacity = "opacity";
			# 				shadow-opacity = "opacity";
			#
			# 				scale-x = {
			# 					curve = "cubic-bezier(0,1.3,1,1)";
			# 					duration = 0.3;
			# 					start = 1;
			# 					end = 0.6;
			# 				};
			# 				scale-y = "scale-x";
			#
			# 				offset-x = "(1 - scale-x) / 2 * window-width";
			# 				offset-y = "(1 - scale-y) / 2 * window-height";
			#
			# 				shadow-scale-x = "scale-x";
			# 				shadow-scale-y = "scale-y";
			# 				shadow-offset-x = "offset-x";
			# 				shadow-offset-y = "offset-y";
			# 			}
			#
			# 			# Animación de APERTURA
			# 			{
			# 				triggers = ["open"];
			# 				opacity = {
			# 					curve = "cubic-bezier(0,1,1,1)";
			# 					duration = 0.5;
			# 					start = 0;
			# 					end = "window-raw-opacity";
			# 				};
			# 				blur-opacity = "opacity";
			# 				shadow-opacity = "opacity";
			#
			# 				scale-x = {
			# 					curve = "cubic-bezier(0,1.3,1,1)";
			# 					duration = 0.5;
			# 					start = 0.6;
			# 					end = 1;
			# 				};
			# 				scale-y = "scale-x";
			#
			# 				offset-x = "(1 - scale-x) / 2 * window-width";
			# 				offset-y = "(1 - scale-y) / 2 * window-height";
			#
			# 				shadow-scale-x = "scale-x";
			# 				shadow-scale-y = "scale-y";
			# 				shadow-offset-x = "offset-x";
			# 				shadow-offset-y = "offset-y";
			# 			}
			#
			# 			# Animación de GEOMETRÍA (modificada para ambos casos)
			# 			{
			# 				triggers = ["geometry"];
			# 				# Cuando la ventana CRECE (abrir/mover/redimensionar)
			# 				scale-x = {
			# 					curve = "cubic-bezier(0,0,0,1.28)";
			# 					duration = 0.5;
			# 					start = "window-width-before / window-width";
			# 					end = 1;
			# 				};
			#
			# 				# Cuando la ventana ENCOGE (cerrar/mover/redimensionar)
			# 				scale-x-reverse = {
			# 					curve = "cubic-bezier(0,0,0,1.28)";
			# 					duration = 0.3;
			# 					start = "window-width / window-width-before";
			# 					end = 1;
			# 				};
			# 				scale-y = {
			# 					curve = "cubic-bezier(0,0,0,1.28)";
			# 					duration = 0.5;
			# 					start = "window-height-before / window-height";
			# 					end = 1;
			# 				};
			# 				scale-y-reverse = {
			# 					curve = "cubic-bezier(0,0,0,1.28)";
			# 					duration = 0.3;
			# 					start = "window-height / window-height-before";
			# 					end = 1;
			# 				};
			# 				offset-x = {
			# 					curve = "cubic-bezier(0,0,0,1.28)";
			# 					duration = 0.5;
			# 					start = "window-x-before - window-x";
			# 					end = 0;
			# 				};
			# 				offset-y = {
			# 					curve = "cubic-bezier(0,0,0,1.28)";
			# 					duration = 0.5;
			# 					start = "window-y-before - window-y";
			# 					end = 0;
			# 				};
			# 				shadow-scale-x = "scale-x";
			# 				shadow-scale-y = "scale-y";
			# 				shadow-offset-x = "offset-x";
			# 				shadow-offset-y = "offset-y";
			# 			}
			# 		];
			# 	}
			# ];
			# Animations
			# animations = true;
			# animation-stiffness = 350;
			# animation-window-mass = 1.0;
			# animation-dampening = 15;
			# animation-clamping = true;
			# animation-for-open-window = "fly-in 120";
			# animation-for-unmap-window = "zoom-out 150";
			# animation-for-transient-window = "slide-down 150";		# fade = true;
			# # Animate move/resize
			# animation-for-move = "slide 150";         # Animate window movement
			# animation-for-resize = "scale 120";       # Animate resizing
			# };
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
