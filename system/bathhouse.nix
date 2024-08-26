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
  hostname = "bathhouse"; # to alllow per-machine config
in {
  imports = [
    ./bathhouse-hardware.nix
  ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true; 

  networking.hostName = hostname;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  users.users.penwing = {
   	openssh.authorizedKeys.keys = [
   	  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN/SQbXjL6O2zjKFdybiMLu7Imc10IGrTMUnRtIxf0jJ nicolas.pinson31@gmail.com"
   	];
  };

  services.logind.lidSwitch = "ignore";
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  
    virtualHosts = {
      "pi.penwing.org" = {
        locations."/".proxyPass = "http://localhost:1080";
      };
  
      "port.penwing.org" = {
        locations."/".proxyPass = "http://localhost:9000";     
      };

      "mov.penwing.org" = {
        locations."/".proxyPass = "http://192.168.1.42:8096";     
      };

      "search.penwing.org" = {
        locations."/".proxyPass = "http://localhost:32768";     
      };

      "www.penwing.org" = {
        root = "/home/penwing/website"; # Serve from the home directory
        #locations."/".root = "$/home/penwing/website";  # Use the directory for the location
      };
    };
  };
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    fastfetch
    docker-compose
    powertop
  ]);

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
