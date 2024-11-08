{ config, pkgs, ... }:

{
  programs = {
  	git = {
      enable = true;
      userName = "WanderingPenwing";       # Replace with your actual name
      userEmail = "wandering.penwingl@2025.icam.fr";  # Replace with your actual email
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    
     
    #carapace.enable = true;
    #carapace.enableNushellIntegration = true;
  };
  
  home.stateVersion = "24.05";
}
