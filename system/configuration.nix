{
config,
pkgs,
pkgs-unstable,
options,
...
}: {

	# Enable networking
	networking.networkmanager.enable = true;

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

	# Configure console keymap
	console.keyMap = "us";

	# Enable Bluetooth
	hardware.bluetooth.enable = true; # enables support for Bluetooth
	hardware.bluetooth.powerOnBoot = true;

	# Enable CUPS to print documents.
	services.printing.enable = true;

	# Define a user account. Don t forget to set a password with ‘passwd’.
	users.users.penwing = {
		isNormalUser = true;
		description = "Penwing";
		extraGroups = ["networkmanager" "wheel" "disk"];
		shell = pkgs.mksh;
	};

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	environment.systemPackages = (with pkgs; [
		# CLIs
		git # code versioning
		bottom # task manager
		micro # text editor
		calc # calculator
		onefetch # code fetch
		nix-search-cli # search packages
		fzf # fuzzy search
		man-pages
		ripgrep
		dust # du replacement

	]) ++ (with pkgs-unstable; [
			yazi
		]);

	environment.variables = {
		EDITOR = "nvim";
		YAZI_CONFIG_HOME = "$HOME/nixos/apps/yazi";
		ENV = "$HOME/nixos/scripts/mkshrc.sh";
	};

	fonts.packages = with pkgs; [
		font-awesome
		powerline-fonts
		powerline-symbols
		nerd-fonts.hurmit
		nerd-fonts.fira-code
		nerd-fonts.mononoki
		linja-pi-pu-lukin
	];

	nix.settings.experimental-features = ["nix-command" "flakes"];
}
