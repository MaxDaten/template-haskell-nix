# Haskell Nix Template

This is a template for a Haskell project using Nix for development and deployment.

With nix as the single requirement and direnv as a optional one, it uses for environment management:

* [direnv](https://direnv.net/) to automatically enter the development environment.
* [nix](https://nixos.org/) to manage dependencies and build the project.
* [devenv](https://devenv.sh) to manage the development environment.
* [treefmt](https://numtide.github.io/treefmt/) to format all project files in the directory structure.

For Haskell development, it uses:

* [ghc](https://www.haskell.org/ghc/) as the compiler.
* [cabal](https://www.haskell.org/cabal/) to build the project.
* [ghcid](https://github.com/ndmitchell/ghcid) to run a development server.
* [hlint](https://github.com/ndmitchell/hlint) to lint the code.
* [fourmolu](https://fourmolu.github.io/) to format the code.

## Directory Structure

```plaintext
.
├── app # Executable source code
│   └── Main.hs
├── src # Core source code
│   └── Hello
│       └── Haskell.hs
├── tests # Test source code
│   ├── Hello
│   │   └── HaskellSpec.hs
│   └── Spec.hs # Utilize hspec-discover to discover all tests ending with Spec.hs and exporting spec :: Spec
├── cabal.project
├── flake.nix       # Nix flake with devenv, packages, checks and apps
├── fourmolu.yaml   # Fourmolu configuration
├── myhaskell.cabal # Cabal file
├── myhaskell.nix   # Nix file the haskell project
└── treefmt.nix     # Formatting tools for the whole project
```

## Usage

With direnv installed, run `direnv allow` to set up the environment or run `nix develop` to
enter development shell manually.

## Development

Run ghcid, continuous compilation and testing of the code:

```sh
devenv up dev
```

Using cabal:

```sh
cabal repl myhaskell:exe:myhaskell
cabal build myhaskell
```

Run compiled module via flake:

```sh
$ nix run
Hello, Haskell!
```

Format all files:

```sh
treefmt
```
