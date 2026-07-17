{ config, ... }:
{
  home.stateVersion = "22.11";

  home.username = "T0modachi";
  home.homeDirectory = "/home/T0modachi";

  home.sessionVariables = {
    TERM = "xterm-256color";
  };

  programs.home-manager.enable = true;

  services.syncthing = {
    enable = true;
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "paperwm@paperwm.github.com"
        ];
      };
    };
  };
}
