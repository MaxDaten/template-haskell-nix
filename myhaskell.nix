{ self, lib, inputs, ... }:
let
  # https://github.com/input-output-hk/haskell.nix/blob/master/ci.nix
  compiler-nix-name = "ghc928";
  name = "myhaskell";
in
{
  perSystem =
    { config
    , self'
    , inputs'
    , pkgs
    , system
    , ...
    }:
    let
      # inherit (pkgs.stdenv) buildPlatform;
      inherit (inputs'.haskell-nix.legacyPackages) haskell-nix;
      # A flake-module in nix/flake-modules/haskell.nix defines haskell-nix
      # packages once, so we can reuse it here, it's more performant.

      project = haskell-nix.cabalProject' {
        inherit name compiler-nix-name;
        evalSystem = "aarch64-darwin";
        src = haskell-nix.cleanSourceHaskell {
          inherit name;
          src = ./.;
        };
      };

      flake = project.flake {
        # Requires remote builder on not linux systems
        # crossPlatforms = p: pkgs.lib.optionals (buildPlatform.isLinux) ([ p.musl64 ]);
      };
    in
    # perSytem flake outputs to be consumed by root flake
    {
      inherit (flake) apps checks packages;

      devShells.dev = project.shellFor {
        withHoogle = false;
        tools = {
          cabal = "latest";
          hlint = "3.6.1"; # compatible with ghc928
          haskell-language-server = "latest";
          ghcid = "latest";
          fourmolu = "0.14.0.0"; # compatible with ghc928
        };
      };

    };
  # General flake output for all systems
  flake = { };
}
