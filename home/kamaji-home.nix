{ config, pkgs, ... }:

{
	imports = [ ./common.nix ];

	services.xserver = {
		xkb.layout = "us";
		xkb.variant = "";
		xkb.options = "compose:ralt,caps:escape";
	};
}
