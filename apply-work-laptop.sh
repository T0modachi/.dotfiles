#!/bin/sh
pushd ~/.dotfiles
sudo nixos-rebuild switch --flake .#work-laptop
popd
