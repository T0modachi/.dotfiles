#!/bin/sh
pushd ~/.dotfiles
nix build  .?submodules=1#homeManagerConfigurations.T0modachi.activationPackage
./result/activate
popd
