{
  description = "My PhD thesis";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  outputs = { self, nixpkgs, devshell, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ devshell.overlays.default ]; };
      in {
        devShells.default = pkgs.devshell.mkShell {
          name = "PhD thesis";
          packages = [
            pkgs.texlive.combined.scheme-full
            pkgs.nixpkgs-fmt
          ];
          commands = [
            {
              name = "clean";
              category = "general commands";
              help = "clean directory";
              command = "cat .gitignore | xargs rm";
            }
          ];
        };
      }
    );
}
