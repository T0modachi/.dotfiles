{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jvergara-ialink";
  home.homeDirectory = "/home/jvergara-ialink";

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
  home.packages = with pkgs; [
    slack
    filezilla
    bitwarden-desktop
    obsidian
    libreoffice
    vlc
    inputs.devenv.packages."${pkgs.system}".devenv
    inputs.nixvim.packages.${pkgs.system}.default
    cachix
    dbeaver-bin
    mob
    appimage-run
    brave
    openfortivpn
    openconnect_openssl
    networkmanager-openconnect
    mqttx
    code-cursor
    nfs-utils
    postman
    openfortivpn-webview
    # for php debuging
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
    #".config/nvim".source = ./../../nvim;
    #".config/nvim".recursive = true;
    ".config/starship.toml".source = ../../starship/starship.toml;
    ".config/ghostty/config".source = ../../ghostty/config;
    ".config/zellij/config.kdl".source = ../../zellij/config.kdl;
    ".config/zellij/layouts/ariztia.kdl".source = ./zellij_templates/ariztia.kdl;
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
    NIXPKGS_ALLOW_INSECURE = 1;
    TERM = "xterm-256color";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      eval "$(direnv hook bash)"
    '';
  };

  programs.git = {
    enable = true;

    settings = {
      user.name = "T0modachi";
      user.email = "jvergarava@gmail.com";
      core = {
        sshCommand = "ssh -i ~/.ssh/id_ed25519";
      };
      push = {
        autoSetupRemote = true;
      };
      safe = {
        directory = "*";
      };
    };

    includes = [
      {
        contents = {
          user = {
            name = "Javier Vergara";
            email = "jvergara@ialink.cl";
          };

          core = {
            sshCommand = "ssh -i ~/.ssh/id_ed25519_ialink";
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
    extraConfig = ''
      Host veria-prod-server
        HostName ec2-54-172-82-205.compute-1.amazonaws.com
        User ec2-user
        # Especifica la clave a usar para el bastion
        IdentityFile ~/.ssh/veria-cloud-template-keypair.pem

      Host veria-vpn-server
        HostName ec2-52-54-112-45.compute-1.amazonaws.com
        User ubuntu
        # Especifica la clave a usar para el bastion
        IdentityFile ~/.ssh/veria-vpn-server-key.pem

      Host pronaca3
        HostName 172.33.0.24
        User ubuntu
        IdentityFile ~/.ssh/veria-cloud-template-keypair.pem
        ProxyJump veria-prod-server

      Host spsa1
        HostName 10.8.0.8
        User ialink
        IdentityFile ~/.ssh/veria-vpn-server-key.pem
        ProxyJump veria-vpn-server

      Host spsa2
        HostName 10.8.0.9
        User ialink
        IdentityFile ~/.ssh/veria-vpn-server-key.pem
        ProxyJump veria-vpn-server

    '';
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.catppuccin
      tmuxPlugins.yank
    ];

    extraConfig = ''
      ${builtins.readFile ./../../tmux/tmux.conf}
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
      plugins = [
        "git"
        "tmux"
      ];
    };
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
    initContent = ''
      eval "$(starship init zsh)"
      eval "$(direnv hook zsh)"
    '';
  };
}
