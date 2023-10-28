#!/bin/sh
pushd ~/.dotfiles
nix build .?submodules=1#homeManagerConfigurations.jvergara-buk.activationPackage
./result/activate
popd
