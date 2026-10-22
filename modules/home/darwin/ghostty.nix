# Ghostty (main terminal on macOS; the app itself is a Homebrew cask).
{ ... }:
let
  c = import ../../palette.nix;
in
{
  xdg.configFile."ghostty/config".text = ''
    theme = Catppuccin Mocha
    background = #${c.background}
    foreground = #${c.foreground}
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
