{ pkgs, ... }:
{
  programs.alacritty.enable = true;

  services.polkit-gnome.enable = true;
}
