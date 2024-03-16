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

## Usage

With direnv installed, run `direnv allow` to set up the environment or run `nix develop` to
enter development shell manually.

## Development

Run ghcid:

```sh
devenv up ghcid
```

Using cabal:

```sh
cabal new-repl myhaskell:exe:myhaskell
cabal new-build myhaskell
```

Run compiled module via flake:

```sh
$ nix run .#myhaskell
Hello, Haskell!
```

Format all files:

```sh
treefmt
```
