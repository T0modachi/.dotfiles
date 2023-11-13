{ config, pkgs,inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "T0modachi";
  home.homeDirectory = "/home/T0modachi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;[
    obsidian
    nerdfonts
    ripgrep
    inputs.devenv.packages."${pkgs.system}".devenv
    cachix
    slack
    mysql-workbench
    nodejs # for lsp support 
    phpactor # for php lsp
    calibre
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

   programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
     ".config/nvim/init.lua".source = ./../../NvChad/init.lua;
     ".config/nvim/lua/core/utils.lua".source = ./../../NvChad/lua/core/utils.lua;
     ".config/nvim/lua/core/default_config.lua".source = ./../../NvChad/lua/core/default_config.lua;
     ".config/nvim/lua/core/bootstrap.lua".source = ./../../NvChad/lua/core/bootstrap.lua;
     ".config/nvim/lua/core/mappings.lua".source = ./../../NvChad/lua/core/mappings.lua;
     ".config/nvim/lua/core/init.lua".source = ./../../NvChad/lua/core/init.lua;
     ".config/nvim/lua/plugins/configs/lazy_nvim.lua".source = ./../../NvChad/lua/plugins/configs/lazy_nvim.lua;
     ".config/nvim/lua/plugins/configs/mason.lua".source = ./../../NvChad/lua/plugins/configs/mason.lua;
     ".config/nvim/lua/plugins/configs/telescope.lua".source = ./../../NvChad/lua/plugins/configs/telescope.lua;
     ".config/nvim/lua/plugins/configs/others.lua".source = ./../../NvChad/lua/plugins/configs/others.lua;
     ".config/nvim/lua/plugins/configs/treesitter.lua".source = ./../../NvChad/lua/plugins/configs/treesitter.lua;
     ".config/nvim/lua/plugins/configs/cmp.lua".source = ./../../NvChad/lua/plugins/configs/cmp.lua;
     ".config/nvim/lua/plugins/configs/nvimtree.lua".source = ./../../NvChad/lua/plugins/configs/nvimtree.lua;
     ".config/nvim/lua/plugins/configs/lspconfig.lua".source = ./../../NvChad/lua/plugins/configs/lspconfig.lua;
     ".config/nvim/lua/plugins/init.lua".source = ./../../NvChad/lua/plugins/init.lua;
     ".config/nvim/lua/custom/chadrc.lua".source = ./nvim-custom/chadrc.lua;
     ".config/nvim/lua/custom/plugins.lua".source = ./nvim-custom/plugins.lua;
     ".config/nvim/lua/custom/configs/lspconfig.lua".source = ./nvim-custom/configs/lspconfig.lua;
     ".config/nvim/lua/custom/configs/overrides.lua".source = ./nvim-custom/configs/overrides.lua;
     ".config/nvim/lua/custom/configs/null-ls.lua".source = ./nvim-custom/configs/null-ls.lua;

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/T0modachi/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;



  programs.git = {
    enable = true;
    # Configure identity
    userName = "T0modachi";
    userEmail = "jvergarava@gmail.com";
    # Use Git Delta for diffs
    delta = {
      enable = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };

  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      rnix-lsp
      ##nodePackages.typescript-language-server
      xclip
      wl-clipboard
    ];

  };

services = {
    syncthing = {
        enable = true;
        extraOptions = ["--config=/home/T0modachi/Documentos/.config/syncthing/" " --data=/home/T0modachi/Documentos"];
    };
};


}
