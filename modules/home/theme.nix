# Tokyo Night OLED for the CLI/TUI apps: btop, eza, fastfetch, fzf, Posting.
# (Neovim's colorscheme is nix/nvim/colorscheme.lua; terminals have their own
# modules. Lazysql has no theme support, so it just inherits the terminal's.)
{ lib, pkgs, ... }:
let
  c = import ../palette.nix;
  h = hex: "#${hex}";
  fg = hex: { foreground = h hex; };
in
{
  # ---------------- btop ----------------
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night-oled";
      theme_background = true;
      vim_keys = true;
    };
  };
  xdg.configFile."btop/themes/tokyo-night-oled.theme".text = ''
    theme[main_bg]="${h c.background}"
    theme[main_fg]="${h c.foreground}"
    theme[title]="${h c.foreground}"
    theme[hi_fg]="${h c.blue}"
    theme[selected_bg]="${h c.highlight}"
    theme[selected_fg]="${h c.blue}"
    theme[inactive_fg]="${h c.muted}"
    theme[graph_text]="${h c.cyan}"
    theme[meter_bg]="${h c.highlight}"
    theme[proc_misc]="${h c.cyan}"
    theme[cpu_box]="${h c.magenta}"
    theme[mem_box]="${h c.green}"
    theme[net_box]="${h c.darkRed}"
    theme[proc_box]="${h c.blue}"
    theme[div_line]="${h c.comment}"
    theme[temp_start]="${h c.green}"
    theme[temp_mid]="${h c.yellow}"
    theme[temp_end]="${h c.red}"
    theme[cpu_start]="${h c.teal}"
    theme[cpu_mid]="${h c.sapphire}"
    theme[cpu_end]="${h c.purple}"
    theme[free_start]="${h c.magenta}"
    theme[free_mid]="${h c.purple}"
    theme[free_end]="${h c.blue}"
    theme[cached_start]="${h c.sapphire}"
    theme[cached_mid]="${h c.blue}"
    theme[cached_end]="${h c.purple}"
    theme[available_start]="${h c.orange}"
    theme[available_mid]="${h c.darkRed}"
    theme[available_end]="${h c.red}"
    theme[used_start]="${h c.green}"
    theme[used_mid]="${h c.teal}"
    theme[used_end]="${h c.cyan}"
    theme[download_start]="${h c.orange}"
    theme[download_mid]="${h c.darkRed}"
    theme[download_end]="${h c.red}"
    theme[upload_start]="${h c.green}"
    theme[upload_mid]="${h c.teal}"
    theme[upload_end]="${h c.cyan}"
    theme[process_start]="${h c.sapphire}"
    theme[process_mid]="${h c.purple}"
    theme[process_end]="${h c.magenta}"
  '';

  # ---------------- eza ----------------
  # macOS would otherwise look in ~/Library/Application Support/eza.
  home.sessionVariables.EZA_CONFIG_DIR = "$HOME/.config/eza";
  xdg.configFile."eza/theme.yml".source = (pkgs.formats.yaml { }).generate "eza-theme.yml" {
    colourful = true;
    filekinds = {
      normal = fg c.foreground;
      directory = fg c.blue // { is_bold = true; };
      symlink = fg c.teal;
      pipe = fg c.comment;
      block_device = fg c.red;
      char_device = fg c.red;
      socket = fg c.comment;
      special = fg c.magenta;
      executable = fg c.green // { is_bold = true; };
      mount_point = fg c.cyan;
    };
    perms = {
      user_read = fg c.yellow;
      user_write = fg c.red;
      user_execute_file = fg c.green;
      user_execute_other = fg c.green;
      group_read = fg c.yellow;
      group_write = fg c.red;
      group_execute = fg c.green;
      other_read = fg c.yellow;
      other_write = fg c.red;
      other_execute = fg c.green;
      special_user_file = fg c.magenta;
      special_other = fg c.comment;
      attribute = fg c.subtext;
    };
    size = {
      major = fg c.subtext;
      minor = fg c.purple;
      number_byte = fg c.foreground;
      number_kilo = fg c.foreground;
      number_mega = fg c.cyan;
      number_giga = fg c.magenta;
      number_huge = fg c.red;
      unit_byte = fg c.subtext;
      unit_kilo = fg c.cyan;
      unit_mega = fg c.magenta;
      unit_giga = fg c.red;
      unit_huge = fg c.orange;
    };
    users = {
      user_you = fg c.foreground;
      user_root = fg c.red;
      user_other = fg c.purple;
      group_yours = fg c.subtext;
      group_other = fg c.muted;
      group_root = fg c.red;
    };
    links = {
      normal = fg c.teal;
      multi_link_file = fg c.cyan;
    };
    git = {
      new = fg c.green;
      modified = fg c.yellow;
      deleted = fg c.red;
      renamed = fg c.teal;
      typechange = fg c.magenta;
      ignored = fg c.comment;
      conflicted = fg c.darkRed;
    };
    punctuation = fg c.comment;
    date = fg c.magenta;
    inode = fg c.subtext;
    blocks = fg c.muted;
    header = fg c.foreground;
    octal = fg c.teal;
    symlink_path = fg c.teal;
    control_char = fg c.cyan;
    broken_symlink = fg c.red;
  };

  # ---------------- fastfetch ----------------
  # Named colors follow the terminal palette, i.e. Tokyo Night OLED.
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = "  ";
        color = {
          keys = "blue";
          title = "magenta";
        };
      };
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "display"
        "wm"
        "terminal"
        "terminalfont"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "battery"
        "break"
        "colors"
      ];
    };
  };

  # ---------------- fzf ----------------
  # Tokyo Night's own fzf colors, on black.
  programs.fzf.colors = {
    bg = h c.background;
    "bg+" = h c.highlight;
    fg = h c.foreground;
    "fg+" = h c.foreground;
    hl = h c.orange;
    "hl+" = h c.orange;
    info = h c.blue;
    prompt = h c.cyan;
    pointer = h c.cyan;
    marker = h c.green;
    spinner = h c.green;
    header = h c.green;
    border = h c.comment;
  };

  # ---------------- Posting ----------------
  xdg.configFile."posting/config.yaml".text = ''
    theme: tokyo-night-oled
  '';
  xdg.dataFile."posting/themes/tokyo-night-oled.yaml".text = ''
    name: tokyo-night-oled
    primary: "${h c.blue}"
    secondary: "${h c.magenta}"
    accent: "${h c.magenta}"
    background: "${h c.background}"
    surface: "${h c.surface}"
    error: "${h c.red}"
    success: "${h c.green}"
    warning: "${h c.yellow}"
  '';
}
