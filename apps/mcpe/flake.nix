{
  description = "A nix flake to run Minecraft Bedrock on Nix/NixOS";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs"; };

  outputs = { self, nixpkgs }: 
  with import nixpkgs { system = "x86_64-linux"; };
  let 
    app = appimageTools.wrapType2 {
      name = "mcbed";
      src = pkgs.fetchurl {
        url = "https://github.com/minecraft-linux/appimage-builder/releases/download/v1.0.0-798/Minecraft_Bedrock_Launcher-x86_64-v1.0.0.798.AppImage";
        sha256 = "xPKt6Xn0pR3IWT2ONqZ6+JPe9q0T5bZvXFQpt0hgzAo=";
      };
      extraPkgs = pkgs: with pkgs; [ pkgs.libgnurl pkgs.mesa ];
    };
  in
  {
    defaultPackage.x86_64-linux = app;
  };
}
