{ pkgs, config, ... }:
{
  # Used to find the project root
  inherit (config.flake-root) projectRootFile;
  programs.hlint.enable = true;
  programs.fourmolu.enable = true;
  programs.fourmolu.package = pkgs.haskellPackages.fourmolu;
  programs.nixpkgs-fmt.enable = true;
  programs.cabal-fmt.enable = true;
}
