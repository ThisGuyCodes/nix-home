# unused: config
{
  config,
  pkgs,
  lib,
  roles,
  tailconfig,
  nixpkgs,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.sessionPath = [
    "$HOME/.local/bin"
    "/opt/homebrew/bin"
    "$HOME/go/bin"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
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
    pkgs.nerd-fonts.jetbrains-mono
    #pkgs.ghostty
    #(pkgs.callPackage ./sigtop.nix {})
    pkgs.ansible
    pkgs.fd
    pkgs.uv
    pkgs.nodejs
    pkgs.bazelisk
    pkgs.bazel-watcher
    pkgs.ripgrep
    pkgs.k9s
    pkgs.kubectl
    pkgs.pv
    pkgs.dust
    pkgs.jq
    pkgs.yq
    pkgs.tree
    pkgs.talosctl
    # pkgs.comby ocaml is borked?
    pkgs.yt-dlp
    pkgs.terraformer
    pkgs.terraform
    pkgs.terragrunt
    # (pkgs.callPackage ./terragrunt.nix { })
    #(pkgs.callPackage ./go-mockery.nix {})
    # pkgs.opentofu
    pkgs.awscli2
    pkgs.aws-vault
    pkgs.podman
    pkgs.podman-tui
    pkgs.ollama

    pkgs.graphviz
    pkgs.pre-commit

    # dev env stuff
    # pkgs.zed-editor
    pkgs.devenv
    pkgs.direnv

    pkgs.ffmpeg

    # lsps
    pkgs.nixd
    pkgs.nil
    pkgs.nixfmt
    pkgs.gopls
    pkgs.go
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/starship.toml".source = dotfiles/starship.toml;
    ".local/bin/bazel".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.bazelisk}/bin/bazelisk";
    # ".local/bin/zed".source =
    #   config.lib.file.mkOutOfStoreSymlink "/opt/homebrew/bin/zed-preview";
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    TG_PROVIDER_CACHE = "1";
    TERRAGRUNT_PROVIDER_CACHE = "1";
    TG_DEPENDENCY_FETCH_OUTPUT_FROM_STATE = "true";
    TERRAGRUNT_DEPENDENCY_FETCH_OUTPUT_FROM_STATE = "true";
    TG_STRICT_CONTROL = "skip-dependencies-inputs";
    TERRAGRUNT_STRICT_CONTROL = "skip-dependencies-inputs";
  };

  programs.zed-editor = {
    enable = false;
    extensions = [
      "ansible"
      "deno"
      "dockerfile"
      "duckyscript"
      "gleam"
      "go-snippits"
      "golangci-lint"
      "gosum"
      "helm"
      "jsonnet"
      "make"
      "markdown-oxide"
      "mcp-server-github"
      "mcp-server-linear"
      "mermaid"
      "nginx"
      "nix"
      "ruby"
      "ruff"
      "sql"
      "ssh-config"
      "starlark"
      "superhtml"
      "templ"
      "terraform"
      "tmux"
      "toml"
      "typos"
      "vhs"
      "wgsl-wesl"
      "xml"
    ];
    userKeymaps = { };
    userSettings = {
      features = {
        edit_prediction_provider = "copilot";
      };
      format_on_save = "on";
      vim_mode = true;
      journal = {
        path = "-";
        hour_format = "hour24";
      };
      tabs = {
        git_status = true;
      };
      relative_line_numbers = true;
      soft_wrap = "editor_width";
      preferred_line_length = 120;
      wrap_guides = [
        80
        120
      ];
      # context_servers = {
      #   linear = {
      #     command = {
      #       path = "npx";
      #       args = [ "-y" "mcp-remote" "https://mcp.linear.app/sse" ];
      #     };
      #     settings = { };
      #   };
      # };
      lsp = {
        typos.initialization_options.diagnosticSeverity = "Hint";
        nil.initialization_options.formatting.command = [ "nixfmt" ];
        terraform-ls.initialization_options = {
          experimentalFeatures.prefillRequiredFields = true;
        };
      };
      agent = {
        always_allow_tool_actions = true;
        default_model = {
          provider = "google";
          model = "gemini-2.5-flash-preview-04-17";
        };
        version = "2";
      };
      context_servers = {
        Github = {
          command = {
            path = "podman";
            args = [
              "run"
              "-i"
              "--rm"
              "-e"
              "GITHUB_PERSONAL_ACCESS_TOKEN"
              "ghcr.io/github/github-mcp-server"
            ];
            env = {
              GITHUB_PERSONAL_ACCESS_TOKEN = "NOOP";
            };
          };
          settings = { };
        };
        # Jira = {
        #   command = {
        #     path = "npx";
        #     args = [ "-y" "mcp-remote" "https://mcp.atlassian.com/v1/sse" ];
        #     env = null;
        #   };
        #   settings = { };
        # };
        "Cloudflare Docs" = {
          command = {
            path = "npx";
            args = [
              "-y"
              "mcp-remote"
              "https://docs.mcp.cloudflare.com/sse"
            ];
            env = null;
          };
          settings = { };
        };
        linear = {
          command = {
            path = "npx";
            args = [
              "-y"
              "mcp-remote"
              "https://mcp.linear.app/sse"
            ];
            env = null;
          };
          settings = { };
        };
      };
    };
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    difftastic.enable = true;
    userName = "Travis Johnson";
    userEmail = "travis@thisguy.codes";
    lfs.enable = true;
    extraConfig = {
      core.editor = "zed --wait";
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };

  programs.git-cliff.enable = true;

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.gh-dash = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = "IdentityAgent %d/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
    matchBlocks = {
      "*" = {
        compression = true;
        forwardAgent = true;
        controlMaster = "no";
        controlPersist = "10m";
        hashKnownHosts = true;
      };
      "bastion-pentest25.babylist-prod.com" = {
        identityFile = "~/.ssh/aws-codecommit";
      };
      "bastion.babylist-stage.com" = {
        identityFile = "~/.ssh/aws-codecommit";
      };
      "bastion.babylist-prod.com" = {
        identityFile = "~/.ssh/aws-codecommit";
      };
    };
  };

  programs.ghostty = {
    enable = false;
    enableZshIntegration = true;
    installVimSyntax = true;
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    attachExistingSession = true;
    exitShellOnExit = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;
    autosuggestion.enable = true;
    autosuggestion.strategy = [
      "match_prev_cmd"
      "history"
      "completion"
    ];
    #initExtra = "eval \"\$(${pkgs.zellij}/bin/zellij setup --generate-completion zsh)\"";
    initContent =
      let
        entries = {
          opts = lib.mkOrder 499 ''
            setopt autopushd
          '';
          aliases = lib.mkOrder 1501 ''
            alias cdg='cd $(git rev-parse --show-toplevel)'
          '';
          # expandDots = lib.mkOrder 1501 ''
          #   function _expand-dot-to-parent-directory-path {
          #     if [[ $LBUFFER = *..  && -d $LBUFFER ]]; then
          #       LBUFFER+='/..'
          #     else
          #       LBUFFER+='.'
          #     fi
          #   }
          #   zle -N _expand-dot-to-parent-directory-path
          #   for keymap in 'emacs' 'viins'; do
          #     bindkey -M "$keymap" "." expand-dot-to-parent-directory-path
          #   done
          # '';
          deriveFunc = lib.mkOrder 1501 ''
            derive() {
              zparseopts -E -D -- \
                u=update \
                -update=update
              if [[ "$update" ]]; then
                (
                  cd ~/.config/nix-darwin
                  nix flake update
                )
              fi
              sudo darwin-rebuild switch --flake ~/.config/nix-darwin
            }
          '';
          viMode = lib.mkOrder 1001 ''
            bindkey -v
          '';
          disableSystemCompinit = lib.mkOrder 0 ''
            skip_global_compinit=1
          '';
          fuzzyCompletions = lib.mkOrder 1001 ''
            zstyle ':completion:*' completer _complete _match _approximate
            zstyle ':completion:*:match:*' original only
            zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'
          '';
          prettyCompletions = lib.mkOrder 1001 ''
            zstyle ':completion:*:matches' group 'yes'
            zstyle ':completion:*:options' description 'yes'
            zstyle ':completion:*:options' auto-description '%d'
            zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
            zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
            zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
            zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
            zstyle ':completion:*:default' list-prompt '%S%M matches%s'
            zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
            zstyle ':completion:*' group-name '''
            zstyle ':completion:*' verbose yes
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
            zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
            zstyle ':completion:*' use-cache true
            zstyle ':completion:*' rehash true
          '';
          menuCompletions = lib.mkOrder 1001 ''
            zstyle ':completion:*' menu select
          '';
          colorCompletions = lib.mkOrder 1001 ''
            zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          '';
          # forGit = lib.mkOrder 2000 ''
          #   zi as'null' wait'1' lucid for sbin wfxr/forgit
          # '';
        };
      in
      lib.mkMerge (lib.attrValues entries);
    history = {
      append = true;
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      saveNoDups = true;
      share = true;
      size = 100000;
    };
    historySubstringSearch.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.ollama =
    if builtins.elem "ollama" roles then
      {
        enable = true;
        host = tailconfig.ip;
      }
    else if builtins.elem "work" roles then
      {
        enable = true;
        host = "localhost";
      }
    else
      { };
}
