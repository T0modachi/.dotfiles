#!/bin/sh
pushd ~/.dotfiles
nix build .?submodules=1#homeManagerConfigurations.jvergara-ialink.activationPackage
./result/activate
popd
