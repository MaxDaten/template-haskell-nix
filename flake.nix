{
  description = "Description for the project";

  inputs = {
    devenv.url = "github:cachix/devenv";
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-root.url = "github:srid/flake-root";

    haskell-nix.url = "github:input-output-hk/haskell.nix";
    #  Should be pinned via haskellNix for caching of ghc compiler
    # nixpkgs.follows = "haskell-nix/nixpkgs-unstable";
  };

  nixConfig = {
    extra-trusted-public-keys = ''
      devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
      hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=
    '';
    extra-substituters = ''
      https://devenv.cachix.org
      https://cache.iog.io
    '';
    allow-import-from-derivation = true;
    accept-flake-config = true;
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, flake-root, ... }:
    flake-parts.lib.mkFlake { inherit self inputs; }
      {
        debug = true;

        imports = [
          inputs.flake-root.flakeModule
          inputs.devenv.flakeModule
          inputs.treefmt-nix.flakeModule
          ./myhaskell.nix
        ];

        systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

        perSystem = { config, self', inputs', pkgs, system, lib, ... }:
          {
            _module.args.pkgs = import nixpkgs { config.allowUnfree = true; inherit system; };

            flake-root.projectRootFile = "flake.nix";
            treefmt.config = import ./treefmt.nix { inherit pkgs config; };

            devShells.default = self'.devShells."myhaskell";
            packages.default = self'.packages."myhaskell:exe:myhaskell";
            apps.default = self'.apps."myhaskell:exe:myhaskell";

            # https://devenv.sh/reference/options/
            devenv.shells."myhaskell" = {
              languages.nix.enable = true;

              packages =
                self'.devShells.dev.buildInputs ++
                self'.devShells.dev.nativeBuildInputs ++
                self'.devShells.dev.propagatedBuildInputs ++
                self'.devShells.dev.propagatedNativeBuildInputs ++
                [
                  config.treefmt.build.wrapper
                ] ++ lib.attrValues config.treefmt.build.programs;

              processes = {
                dev = {
                  exec = "ghcid";
                  process-compose = {
                    depends_on.watch-style.condition = "process_started";
                    depends_on.watch-statics.condition = "process_started";
                    readiness_probe = {
                      exec.command = "curl -s http://localhost:8080/";
                      initial_delay_seconds = 2;
                      period_seconds = 30;
                    };
                    shutdown.signal = 2; # SIGINT (Ctrl-C) to ghcid
                  };
                };
              };
            };
          };
      };
}

