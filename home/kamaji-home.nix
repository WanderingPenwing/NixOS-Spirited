{ config, pkgs, ... }:

{
#   home.packages = with pkgs; [
#     dconf
#   ];
# 
#   dconf = {
#     enable = true;
#     settings = {
#       "org/gnome/desktop/interface" = {
#         color-scheme = "prefer-dark";
#       };
#     };
#   };
  
  programs.git = {
    enable = true;

    # Git global user settings
    userName = "WanderingPenwing";       # Replace with your actual name
    userEmail = "wandering.penwingl@2025.icam.fr";  # Replace with your actual email

    # Git configuration options
    extraConfig = {
      # Set default branch name when initializing a repository
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "24.05";
}
