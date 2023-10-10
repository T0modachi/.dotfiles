#!/bin/sh
pushd ~/.dotfiles
nix build .#homeManagerConfigurations.T0modachi.activationPackage
./result/activate
popd
