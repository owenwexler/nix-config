# Ghostty (main terminal on macOS; the app itself is a Homebrew cask).
{ lib, ... }:
let
  c = import ../../palette.nix;
  ansi = lib.concatImapStringsSep "\n" (i: hex: "palette = ${toString (i - 1)}=#${hex}") c.ansi;
in
{
  xdg.configFile."ghostty/config".text = ''
    # ---- Tokyo Night OLED ----
    background = #${c.background}
    foreground = #${c.foreground}
    cursor-color = #${c.cursor}
    selection-background = #${c.highlight}
    selection-foreground = #${c.foreground}
    ${ansi}
    background-opacity = 1

    font-family = JetBrainsMono Nerd Font
    font-size = 13

    window-padding-x = 6
    window-padding-y = 6
    macos-titlebar-style = hidden
    macos-option-as-alt = right
    confirm-close-surface = false
    shell-integration-features = no-cursor
  '';
}
