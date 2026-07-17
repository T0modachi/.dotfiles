{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # Development
    inputs.devenv.packages."${pkgs.system}".devenv
    inputs.nixvim.packages.${pkgs.system}.default
    inputs.llm-agents.packages.${pkgs.system}.omp
    inputs.llm-agents.packages.${pkgs.system}.codegraph
    inputs.mcp-servers-nix.packages.${pkgs.system}.context7-mcp
    inputs.mcp-servers-nix.packages.${pkgs.system}.tavily-mcp
    cachix
    awscli2
    opencode
    zola
    herdr

    # Apps
    obsidian
    brave
    libreoffice
    slack
    anydesk
    dbeaver-bin
    inputs.zen-browser-flake.packages.${pkgs.system}.default
    ghostty
    kitty
    bitwarden-cli
    bitwarden-desktop
    discord
    vlc
    ollama

    # CLI tools
    starship
    lazygit
    sesh
    zoxide
    ripgrep
    fzf
    fd
    jq
    docker-compose

    # Gaming (see gaming.nix for vulkan/wine specifics)
    steam-run
    appimage-run

    # Profiling / misc
    glamoroustoolkit
    heaptrack

    # Wayland utilities
    swaybg
    xwayland-satellite
    wl-clipboard
    xclip
    gnomeExtensions.paperwm
  ];
}
