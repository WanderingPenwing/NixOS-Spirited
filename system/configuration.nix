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
  console.keyMap = "fr";

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
    #shell = pkgs.nushell;
  };

  programs.nushell.enable = true;
  programs.defaultShell = pkgs.nushell;

  #environment.shells = [ pkgs.nu ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = (with pkgs; [

    # CLIs
    starship # shell more pretty
    git # code versioning
    carapace # shell completion
    bottom # task manager
    micro # text editor
    calc # calculator
    onefetch # code fetch
    
  ]) ++ (with pkgs-unstable; [
    yazi
  ]);

  environment.variables = {
    EDITOR = "micro";
  };

  environment.etc."config/nushell/config.nu".text = ''
      # Set up aliases
      alias m = "micro"
      alias y = "yazi"
      alias rebuild = "~/nixos/scripts/rebuild.sh"
  '';

  fonts.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    (nerdfonts.override {fonts = ["Hermit" "FiraCode" "Mononoki"];})
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
