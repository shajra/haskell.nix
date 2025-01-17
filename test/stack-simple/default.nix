{ stdenv, lib, pkgs, mkStackPkgSet, haskellLib, testSrc }:

with lib;

let
  # ./pkgs.nix and ./stack-simple.nix are generated by running
  # stack-to-nix -o .
  pkgSet = mkStackPkgSet {
    stack-pkgs = import ./pkgs.nix;
    pkg-def-extras = [];
    modules = [];
  };

  packages = pkgSet.config.hsPkgs;

in pkgs.recurseIntoAttrs {
  stack-simple-exe = (haskellLib.check packages.stack-simple.components.exes.stack-simple-exe) // {
      # Attributes used for debugging with nix repl
      inherit pkgSet packages;
  };
  stack-simple-test = packages.stack-simple.checks.stack-simple-test;
  stack-simple-checks = packages.stack-simple.checks;
  stack-simple-shell = packages.shellFor { tools = { cabal = "3.4.0.0"; }; };
}
