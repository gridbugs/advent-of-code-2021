{ pkgs ? import <nixpkgs> {} }:
let
  ocamlInit = pkgs.writeText "ocamlinit" ''
    #require "base";;
    #require "core";;
  '';
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
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
  ]);
  shellHook = ''
    alias utop="utop -init ${ocamlInit}"
  '';
}
