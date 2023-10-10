#!/bin/sh
pushd ~/.dotfiles
nix build .#homeManagerConfigurations.jvergara-buk.activationPackage
./result/activate
popd
