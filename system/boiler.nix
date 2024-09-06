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
  hostname = "boiler"; # to alllow per-machine config
in {
  imports = [
    ./boiler-hardware.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = hostname;
  networking.interfaces.enp3s0.wakeOnLan.enable = true;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  users.users.penwing = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN/SQbXjL6O2zjKFdybiMLu7Imc10IGrTMUnRtIxf0jJ nicolas.pinson31@gmail.com"
        ];
  };

  fileSystems."/media/storage" = {
    device = "/dev/disk/by-uuid/505e9428-2d47-4e58-ad2e-8feb0cfdd459";
    fsType = "ext4"; # or the type of your filesystem
    options = [ "defaults" ];
  };

  networking.firewall.allowedTCPPorts = [ 80 1180 ];

  systemd.timers."poweroff" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 1:00:00";
        Unit = "poweroff.service";
      };
  };
  
  systemd.services."poweroff" = {
    script = ''
      ${pkgs.coreutils}/bin/shutdown -h now >> /var/log/poweroff.log 2>&1
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    fastfetch
    docker-compose
    ethtool
    cron
  ]);

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
