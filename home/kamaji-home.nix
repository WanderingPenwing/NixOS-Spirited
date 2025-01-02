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
  
  home.stateVersion = "24.05";
}
