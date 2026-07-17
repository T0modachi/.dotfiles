{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    gcc
    rustc
    cargo
    lua
    git-crypt
    gnupg
    gnumake
    unzip
    openvpn
  ];
}
