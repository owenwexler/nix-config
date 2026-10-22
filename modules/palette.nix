# Catppuccin Dark: the Catppuccin Mocha accents on a true black background
# with pure white text. Every themed app reads its colors from here.
# Values are "rrggbb" without the leading '#'.
rec {
  background = "000000";
  foreground = "ffffff";

  # Mocha surfaces, nudged darker so they sit well on true black.
  surface0 = "1e1e2e";
  surface1 = "313244";
  surface2 = "45475a";
  overlay0 = "6c7086";
  overlay1 = "7f849c";
  subtext = "bac2de";

  # Mocha accents
  rosewater = "f5e0dc";
  flamingo = "f2cdcd";
  pink = "f5c2e7";
  mauve = "cba6f7";
  red = "f38ba8";
  maroon = "eba0ac";
  peach = "fab387";
  yellow = "f9e2af";
  green = "a6e3a1";
  teal = "94e2d5";
  sky = "89dceb";
  sapphire = "74c7ec";
  blue = "89b4fa";
  lavender = "b4befe";

  accent = blue;
  cursor = rosewater;

  # The 16 ANSI colors, same as the Omarchy catppuccin-dark theme.
  ansi = [
    surface2 # 0 black
    red # 1
    green # 2
    yellow # 3
    blue # 4
    pink # 5 magenta
    teal # 6 cyan
    subtext # 7 white
    "585b70" # 8 bright black
    red # 9
    green # 10
    yellow # 11
    blue # 12
    pink # 13
    teal # 14
    "a6adc8" # 15 bright white
  ];
}
