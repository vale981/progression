{
  description = "A python progress bar in ascii art.";

  inputs = {
    utils.url = "github:vale981/hiro-flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, utils, nixpkgs, ... }:
    (utils.lib.poetry2nixWrapper nixpkgs {
      name = "progression";
      poetryArgs = {
        projectDir = ./.;
      };
    });
}
