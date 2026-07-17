#!/bin/sh
set -e
cd ~/.dotfiles

case "${1:-all}" in
  system|nixos)
    sudo nixos-rebuild switch --flake .#nix-laptop
    ;;
  home|user)
    nix build .?submodules=1#homeManagerConfigurations.T0modachi.activationPackage
    ./result/activate
    ;;
  all)
    sudo nixos-rebuild switch --flake .#nix-laptop
    nix build .?submodules=1#homeManagerConfigurations.T0modachi.activationPackage
    ./result/activate
    ;;
  *)
    echo "Usage: $0 [system|home|all]"
    echo "  system  — nixos-rebuild switch"
    echo "  home    — home-manager activate"
    echo "  all     — both (default)"
    exit 1
    ;;
esac
