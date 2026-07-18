{ pkgs, ... }:
{
  nix.package = pkgs.nixVersions.latest;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nix.settings.trusted-users = [
    "root"
    "T0modachi"
  ];

  nix.settings.extra-substituters = [
    "https://noctalia.cachix.org"
  ];
  nix.settings.extra-trusted-public-keys = [
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  system.stateVersion = "25.05";
}
