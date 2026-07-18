{ ... }:
{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      shell.font_family = "BerkeleyMono Nerd Font";
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      notification.enable_daemon = true;
      wallpaper = {
        enabled = true;
        directory = "~/Pictures/Wallpapers";
      };
      lockscreen.enabled = true;
    };
  };
}
