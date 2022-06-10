{
  description = "Advent of Code 2021";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        ocamlInit = pkgs.writeText "ocamlinit" ''
          #require "base";;
          #require "core";;
        '';
      in
      with pkgs;
      {
        devShell = mkShell {
          buildInputs = [
            dune_2
          ] ++ (with ocamlPackages;
          [
            ocaml
            ocaml-lsp
            ocamlformat
            core
            core_extended
            re2
            findlib
            utop
            merlin
            ppx_sexp_conv
            ppx_fields_conv
            ppx_deriving
            ppx_expect
            ppx_compare
          ]);
          shellHook = ''
            alias utop="utop -init ${ocamlInit}"
          '';
        };
      }
    );
}
