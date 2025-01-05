{ config, pkgs, ... }:

{
  programs = {
  	git = {
      enable = true;
      userName = "WanderingPenwing";       # Replace with your actual name
      userEmail = "wandering.penwing@gmail.com";  # Replace with your actual email
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Breeze-Dark";
  #     package = pkgs.libsForQt5.breeze-gtk;
  #   };
  # };
  home.stateVersion = "24.05";
}
