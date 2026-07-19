{ pkgs, ... }:
{
  users.users.T0modachi = {
    isNormalUser = true;
    description = "T0modachi";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  programs.zsh.enable = true;

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;
}
