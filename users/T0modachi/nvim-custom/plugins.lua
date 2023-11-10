local plugins = {
 {
   "williamboman/mason.nvim",
   opts = {
      ensure_installed = {
        "lua-language-server",
        "prettier",
        "rnix-lsp",
        "typescript-language-server",
        --"phpactor" installed by nix on home-manager
      },
    },
    },
      {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
}

return plugins
