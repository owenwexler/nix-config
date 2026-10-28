# Zsh + Oh My Zsh, with the aliases from nix/aliases.txt.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      share = true;
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "docker"
        "golang"
        "rust"
      ];
    };

    initContent = lib.mkMerge [
      # NVM is installed by dev-runtimes.nix. --no-use keeps the Nix-provided
      # Node as the default until you run `nvm use`, so shells start fast.
      ''
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
        [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
      ''

      # The aliases file goes last so it wins over Oh My Zsh's own aliases.
      (lib.mkAfter ''
        # ---- nix/aliases.txt ----
        ${builtins.readFile ../../aliases.txt}

        alias ff='fastfetch'
        ${
          if isDarwin then
            ''
              # macOS-only aliases
              alias o="open ." # Open the current directory in Finder
              alias brewnoupdate="HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_AUTO_UPGRADE=1 brew"
              alias sha256="shasum -a 256"
            ''
          else
            ''
              # Linux-only aliases
              alias o="xdg-open . >/dev/null 2>&1" # Open the current directory in Nautilus
            ''
        }
      '')
    ];
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.dotnet/tools"
    "$HOME/.grok/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # `delfromredis KEY` (alias in aliases.txt) deletes a key from local Redis.
  home.file."delfromredis.sh" = {
    source = ../../delfromredis.sh;
    executable = true;
  };

  # zoxide replaces `cd` itself (`cd foo` jumps to the best match for foo).
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd"
      "cd"
    ];
  };

  programs.fzf.enable = true;

  # eza, but the ls/ll/lt aliases come from aliases.txt, not Home Manager.
  programs.eza = {
    enable = true;
    enableZshIntegration = false;
    icons = "auto";
  };

  programs.bat = {
    enable = true;
    # "ansi" follows the terminal palette, which is Tokyo Night OLED.
    config.theme = "ansi";
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 10;
    terminal = "tmux-256color";
    historyLimit = 50000;
    extraConfig = ''
      set -g set-clipboard on
      set -as terminal-features ',*:RGB'
    '';
  };
}
