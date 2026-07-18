{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Language Servers (for omp LSP integration)
    typescript-language-server            # TypeScript/JavaScript
    vscode-langservers-extracted          # HTML, CSS, JSON, ESLint servers
    yaml-language-server                  # YAML
    lua-language-server                   # Lua
    nil                                   # Nix
    marksman                              # Markdown
    pyright                               # Python
    gopls                                 # Go
    terraform-ls                          # Terraform
    ruby-lsp                              # Ruby
    phpactor                              # PHP

    # Linters (LSP-based)
    ruff                                  # Python linter/formatter (LSP)

    # Formatters/Linters (CLI tools - for bash use, not LSP integrated)
    statix                                # Nix linter
    yamllint                              # YAML linter
    alejandra                             # Nix formatter
    prettierd                             # JS/TS/HTML/CSS/Markdown formatter (daemon)
    prettier                              # JS/TS/HTML/CSS/Markdown formatter
    stylua                                # Lua formatter
    yamlfmt                               # YAML formatter

    # Debuggers (for omp DAP integration)
    python3Packages.debugpy               # Python debugger
  ];
}
