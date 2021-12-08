{
  description = "A python progress bar in ascii art.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    poetry2nix.url = "github:nix-community/poetry2nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    let
      name = "progression";
    in {
      overlay = nixpkgs.lib.composeManyExtensions [
        poetry2nix.overlay
        (final: prev: {
          ${name} = (prev.poetry2nix.mkPoetryApplication {
            projectDir = ./.;
            doCheck = false;
            preferWheels = true;
          });
        })

      ];
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
        rec {
          packages = {
            ${name} = pkgs.${name};
          };

          defaultPackage = packages.${name};
          devShell = (pkgs.poetry2nix.mkPoetryEnv {
            projectDir = ./.;

            editablePackageSources = {
              ${name} = ./${name};
            };
          }).env.overrideAttrs (oldAttrs: {
            buildInputs = [ pkgs.poetry pkgs.pyright ];
          });
        }));
}
