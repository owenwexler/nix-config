# Helix, Vim, Zed and VS Code configs from the dotfiles repo.
# (The editors themselves are installed per platform.)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  dots = ../..; # the nix/ directory
  vscodeUserDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support/Code/User"
    else
      "${config.xdg.configHome}/Code/User";
in
{
  # ---- Helix (read-only links; Helix never writes its config) ----
  home.packages = [ pkgs.helix ];
  xdg.configFile = {
    "helix/config.toml".source = "${dots}/helix/config.toml";
    "helix/languages.toml".source = "${dots}/helix/languages.toml";
    "helix/themes/nightwolf.toml".source = "${dots}/helix/themes/nightwolf.toml";
  };

  # ---- Vim ----
  home.file.".vimrc".source = "${dots}/vimrc";

  # ---- Zed and VS Code ----
  # Both apps rewrite their own settings files, so these are copied once
  # (only if missing) instead of being linked read-only.
  home.activation.editorSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    seed() { # seed SRC DEST: copy only if DEST does not exist yet
      if [ ! -e "$2" ]; then
        run mkdir -p "$(dirname "$2")"
        run cp -R "$1" "$2"
        run chmod -R u+w "$2"
      fi
    }
    zed="${config.xdg.configHome}/zed"
    if [ ! -e "$zed/settings.json" ]; then
      seed "${dots}/zed/settings.json" "$zed/settings.json"
      # Same settings, but with the JetBrains Mono Nerd Font used everywhere else
      run ${pkgs.gnused}/bin/sed -i 's/MesloLGL Nerd Font/JetBrainsMono Nerd Font/g' "$zed/settings.json"
    fi
    seed "${dots}/zed/keymap.json" "$zed/keymap.json"
    seed "${dots}/zed/snippets" "$zed/snippets"
    seed "${dots}/zed/themes" "$zed/themes"

    seed "${dots}/vscode-settings.json" "${
      if pkgs.stdenv.hostPlatform.isDarwin then "$HOME/" else ""
    }${vscodeUserDir}/settings.json"
  '';
}
