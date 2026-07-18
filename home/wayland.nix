{ pkgs, ... }:
{
  programs.alacritty.enable = true;
  programs.swaylock.enable = true;

  services.swayidle = {
    enable = true;
    events = {
      "before-sleep" = "${pkgs.swaylock}/bin/swaylock -fF";
      "lock"         = "${pkgs.swaylock}/bin/swaylock -fF";
    };
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
    ];
  };

  services.polkit-gnome.enable = true;
}
