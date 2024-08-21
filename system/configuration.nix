{
  config,
  pkgs,
  pkgs-unstable,
  options,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    extraGroups = ["networkmanager" "wheel" "input" "plugdev"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = (with pkgs; [

    # CLIs
    starship # shell more pretty
    git # code versioning
    bottom # task manager
    micro # text editor
    
  ]) ++ (with pkgs-unstable; [
    yazi
  ]);

  environment.variables = {
    EDITOR = "micro";
  };

  fonts.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    (nerdfonts.override {fonts = ["Hermit" "FiraCode" "Mononoki"];})
  ];

  environment.interactiveShellInit = ''
    if [ -f $HOME/nixos/scripts/shell_config ]; then
        . $HOME/nixos/scripts/shell_config
    else
        echo "error shell loading config"
    fi
  '';

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
