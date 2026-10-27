# Kitty (alternate terminal on both platforms). Ghostty (macOS) and Foot
# (NixOS) are configured in the platform modules.
{ lib, ... }:
let
  c = import ../palette.nix;
  ansi = lib.concatImapStringsSep "\n" (i: hex: "color${toString (i - 1)} #${hex}") c.ansi;
in
{
  xdg.configFile."kitty/kitty.conf".text = ''
    font_family      JetBrainsMono Nerd Font
    bold_font        auto
    italic_font      auto
    bold_italic_font auto
    font_size        12

    cursor_trail 10
    confirm_os_window_close 0
    enable_audio_bell no
    macos_option_as_alt left

    # ---- Tokyo Night OLED ----
    foreground           #${c.foreground}
    background           #${c.background}
    background_opacity   1.0
    selection_foreground #${c.background}
    selection_background #${c.fgSoft}
    cursor               #${c.cursor}
    cursor_text_color    #${c.background}
    url_color            #${c.fgSoft}
    active_border_color   #${c.purple}
    inactive_border_color #${c.comment}
    active_tab_foreground   #${c.background}
    active_tab_background   #${c.magenta}
    inactive_tab_foreground #${c.foreground}
    inactive_tab_background #${c.surface}
    tab_bar_background      #${c.background}
    ${ansi}
  '';
}
