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

  systemd.timers."poweroff" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 1:00:00";
        Unit = "poweroff.service";
      };
  };

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
      "penwing.org" = {
        locations."/".proxyPass = "http://localhost:2180";
      };
      "storage.penwing.org" = {
		#locations."/".proxyPass = "http://localhost:1380";
		locations."/Games/" = {
			proxyPass = "http://localhost:1380/Games/";
	        extraConfig = ''
	          add_header Cross-Origin-Opener-Policy "same-origin";
	          add_header Cross-Origin-Embedder-Policy "require-corp";
	        '';
	      };
      };
      
      "www.penwing.org" = {
        locations."/".proxyPass = "http://localhost:2180";
      };
      
      "port.penwing.org" = {
        locations."/".proxyPass = "http://localhost:9000";
      };

      "search.penwing.org" = {
        locations."/".proxyPass = "http://localhost:32768";
      };

      "git.penwing.org" = {
        locations."/".proxyPass = "http://localhost:3000";
      };

      "smms.penwing.org" = {
        locations."/".proxyPass = "http://localhost:4080";
      };

      "movie.penwing.org" = {
        locations."/".proxyPass = "http://localhost:8096";
      };

      "pdf.penwing.org" = {
        locations."/".proxyPass = "http://localhost:1280";
      };

      "book.penwing.org" = {
        locations."/".proxyPass = "http://localhost:5000";
      };

      "doc.penwing.org" = {
         locations."/".proxyPass = "http://localhost:5680";
       };
		
		"matrix.penwing.org" = {
			locations = {
        # Well-known endpoints for Matrix federation
				"/.well-known/matrix/server" = {
				  return = "200 '{\"m.server\": \"matrix.penwing.org:443\"}'";
				  extraConfig = ''
					add_header Content-Type application/json;
					add_header Access-Control-Allow-Origin *;
				  '';
				};
				
				"/.well-known/matrix/client" = {
				  return = "200 '{\"m.homeserver\":{\"base_url\":\"https://matrix.penwing.org\"}}'";
				  extraConfig = ''
					add_header Content-Type application/json;
					add_header Access-Control-Allow-Origin *;
				  '';
				};
				
				# Proxy all other requests to Tuwunel
				"/" = {
				  proxyPass = "http://localhost:8008";
				  extraConfig = ''
					proxy_set_header X-Forwarded-Host $host;
					proxy_buffering off;
					proxy_request_buffering off;
				  '';
				};
			};
		};
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 2180 4080 8008 29334];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    fastfetch
    docker-compose
    ethtool
    cron
    zip
	dust
  ]);

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
