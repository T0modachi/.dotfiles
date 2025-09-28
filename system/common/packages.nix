{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    git
    gemini-cli
    # vim is in common packages
    wget
    home-manager # jvv: incluyo segun instrucciones de https://www.youtube.com/watch?v=FcC2dzecovw
    gcc
    rustc
    cargo
    lua
    # git is in common packages
    git-crypt
    gnupg
    (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { })
    gnumake
    docker-compose
    kitty
    ollama
    unzip
    unrar
    ripgrep
    fzf
    fd
    starship
    lazygit
    sesh
    zoxide
    xclip
    wl-clipboard
    jq
    #aider-chat
    #pharo
    steam-run
    glamoroustoolkit
    #logseq
    heaptrack
    discord
    awscli2
    vlc
    keymapp
    zellij
    ghostty
    bitwarden-cli
    # gemini-cli is in common packages
    crush
    opencode
    openvpn
  ];
}
