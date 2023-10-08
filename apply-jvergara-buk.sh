#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./users/jvergara-buk/home.nix
popd
