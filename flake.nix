{
  description = "My Elixir application";

  inputs = {
    beam-flakes = {
      url = "github:mayl/nix-beam-flakes/igniter";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs @ {
    beam-flakes,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [beam-flakes.flakeModule];

      systems = ["aarch64-linux" "x86_64-linux"];

      perSystem = {pkgs, lib, self', ...}: let
        beamPackages = pkgs.beam.packagesWith pkgs.beam.interpreters.erlang_26;
        mixReleaseAttrs = {
          src = ./test_project;
          mixNixDeps = import ./test_project/deps.nix {inherit pkgs lib beamPackages;};
          version = "0.1";
          pname = "testProject";
          # add or remove this flag to trigger the issue:
          ERL_FLAGS = "+JPperf true";
        };
      in
        {
          packages.default = beamPackages.mixRelease mixReleaseAttrs;
          beamWorkspace = {
          enable = true;
          devShell = {
            languageServers.elixir = true;
            languageServers.erlang = false;
          };
          versions = {
            elixir = "1.16.2";
            erlang = "26.2.3";
          };
        };
      };
    };
}
