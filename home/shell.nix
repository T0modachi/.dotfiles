{ config, ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      eval "$(direnv hook bash)"
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -la";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    initContent = ''
      eval "$(starship init zsh)"
      eval "$(direnv hook zsh)"
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
