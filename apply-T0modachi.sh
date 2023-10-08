#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./users/T0modachi/home.nix
popd
