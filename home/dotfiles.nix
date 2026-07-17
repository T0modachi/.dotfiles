{
  home.file = {
    ".config/starship.toml".source = ../starship/starship.toml;
    ".config/ghostty/config".source = ../ghostty/config;
    ".config/niri/config.kdl" = {
      source = ../niri/config.kdl;
      force = true;
    };
    ".omp/agent/config.yml".source = ../omp/config.yml;
    ".omp/agent/mcp.json".source = ../omp/mcp.json;
    ".omp/agent/RULES.md".source = ../omp/RULES.md;
  };
}
