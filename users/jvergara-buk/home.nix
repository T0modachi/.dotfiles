{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jvergara-buk";
  home.homeDirectory = "/home/jvergara-buk";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;[
    slack
    filezilla
    bitwarden
    obsidian
    teleport_12
    kubectl
    libreoffice
    vlc
    unrar
    nerdfonts
    ripgrep
    chromium
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
  #  /etc/profiles/per-user/jvergara-buk/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "T0modachi";
    userEmail = "jvergarava@gmail.com";

    extraConfig = {
      core = {
        sshCommand = "ssh -i ~/.ssh/id_ed25519";
      };
    };

    includes = [
      {
        contents = {
          user = {
            name = "Javier Vergara";
	    email = "jvergara@buk.cl";
	  };

	core = {
	  sshCommand = "ssh -i ~/.ssh/id_ed25519_buk";
        };
      };

      condition = "gitdir:~/work/";
      }
    ];
  };

  programs.ssh = {
    enable = true;
    matchBlocks."*" = {
      extraOptions = {
        AddKeysToAgent = "yes";
        IdentitiesOnly = "yes";
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
    ];

  };



}
