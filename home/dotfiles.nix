{
  home.file = {
    ".config/starship.toml".source = ../configs/starship/starship.toml;
    ".config/ghostty/config".source = ../configs/ghostty/config;
    ".config/niri/config.kdl" = {
      source = ../configs/niri/config.kdl;
      force = true;
    };
    ".omp/agent/config.yml".source = ../configs/omp/config.yml;
    ".omp/agent/mcp.json".source = ../configs/omp/mcp.json;
    ".omp/agent/RULES.md".source = ../configs/omp/RULES.md;
  };
}
