# Tokyo Night OLED (https://github.com/Justin-De-Sio/omarchy-tokyoled-theme):
# Tokyo Night Night accents on a true black background with pure white text.
# Every themed app reads its colors from here.
# Values are "rrggbb" without the leading '#'.
rec {
  background = "000000";
  foreground = "ffffff";

  # Surfaces, darkest to lightest
  surface = "16161e"; # sidebars, cards, inactive tabs
  highlight = "292e42"; # selections, meters
  border = "414868";
  comment = "565f89";
  muted = "737aa2"; # inactive text
  subtext = "a9b1d6";
  fgSoft = "c0caf5"; # Tokyo Night's own text color

  # Accents
  blue = "7aa2f7";
  cyan = "7dcfff";
  sapphire = "2ac3de";
  magenta = "bb9af7";
  purple = "9d7cd8";
  red = "f7768e";
  darkRed = "db4b4b";
  orange = "ff9e64";
  yellow = "e0af68";
  green = "9ece6a";
  teal = "73daca";

  accent = blue;
  cursor = fgSoft;

  # The 16 ANSI colors, exactly as in the theme's colors.toml.
  ansi = [
    "32344a" # 0 black
    "f7768e" # 1 red
    "9ece6a" # 2 green
    "e0af68" # 3 yellow
    "7aa2f7" # 4 blue
    "ad8ee6" # 5 magenta
    "449dab" # 6 cyan
    "787c99" # 7 white
    "444b6a" # 8 bright black
    "ff7a93" # 9
    "b9f27c" # 10
    "ff9e64" # 11
    "7da6ff" # 12
    "bb9af7" # 13
    "0db9d7" # 14
    "acb0d0" # 15 bright white
  ];
}
