{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ nushell ];
  
  programs = {
  	git = {
      enable = true;
      userName = "WanderingPenwing";       # Replace with your actual name
      userEmail = "wandering.penwingl@2025.icam.fr";  # Replace with your actual email
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[x](bold red)";
          vimcmd_symbol = "[<](bold green)";
        };
        git_commit = {
          tag_symbol = " tag ";
        };
        git_status = {
          ahead = ">";
          behind = "<";
          diverged = "<>";
          renamed = "r";
          deleted = "x";
        };
        aws = { symbol = "aws "; };
        azure = { symbol = "az "; };
        bun = { symbol = "bun "; };
        c = { symbol = "C "; };
        cobol = { symbol = "cobol "; };
        conda = { symbol = "conda "; };
        crystal = { symbol = "cr "; };
        cmake = { symbol = "cmake "; };
        daml = { symbol = "daml "; };
        dart = { symbol = "dart "; };
        deno = { symbol = "deno "; };
        dotnet = { symbol = ".NET "; };
        directory = {
          read_only = " ro";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            docs = " 🕮  ";
            dl = "   ";
            pics = "   ";
            nixos = " ❆ ";
          };
        };
        docker_context = { symbol = " "; };
        git_branch = { symbol = " "; };
        lua = { symbol = "lua "; };
        nodejs = { symbol = " "; };
        memory_usage = { symbol = "memory "; };
        nix_shell = { symbol = "nix "; };
        os = { disabled = true; };
        package = { symbol = " "; };
        php = { symbol = "php "; };
        python = { symbol = "py "; };
        rust = { symbol = " "; };
        scala = { symbol = "scala "; };
        spack = { symbol = "spack "; };
        solidity = { symbol = "solidity "; };
        status = { symbol = "[x](bold red) "; };
        sudo = { symbol = "sudo "; };
        swift = { symbol = "swift "; };
        typst = { symbol = "typst "; };
        terraform = { symbol = "terraform "; };
        zig = { symbol = "zig "; };
      };
    };

    nushell = { enable = true;
          # The config.nu can be anywhere you want if you like to edit your Nushell with Nu
          configFile.source = ../apps/nushell/config.nu;
    };
  };
  
  home.stateVersion = "24.05";
}
