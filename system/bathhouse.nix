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
  services.openssh.settings.PasswordAuthentication = true;

  systemd.services.custom-acpi-unbind = {
    description = "Unbind ACPI button driver at startup";
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo PNP0C0D:00 > /sys/bus/acpi/drivers/button/unbind'";
      RemainAfterExit = true;
    };
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
  
    # CLIs
    bc # calculator
  ]);

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
