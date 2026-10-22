# Catppuccin Dark for the CLI/TUI apps: btop, eza, fastfetch, fzf, Posting.
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
      color_theme = "catppuccin-dark";
      theme_background = true;
      vim_keys = true;
    };
  };
  xdg.configFile."btop/themes/catppuccin-dark.theme".text = ''
    theme[main_bg]="${h c.background}"
    theme[main_fg]="${h c.foreground}"
    theme[title]="${h c.foreground}"
    theme[hi_fg]="${h c.blue}"
    theme[selected_bg]="${h c.surface1}"
    theme[selected_fg]="${h c.blue}"
    theme[inactive_fg]="${h c.overlay1}"
    theme[graph_text]="${h c.flamingo}"
    theme[meter_bg]="${h c.surface1}"
    theme[proc_misc]="${h c.flamingo}"
    theme[cpu_box]="${h c.mauve}"
    theme[mem_box]="${h c.green}"
    theme[net_box]="${h c.maroon}"
    theme[proc_box]="${h c.blue}"
    theme[div_line]="${h c.overlay0}"
    theme[temp_start]="${h c.green}"
    theme[temp_mid]="${h c.yellow}"
    theme[temp_end]="${h c.red}"
    theme[cpu_start]="${h c.teal}"
    theme[cpu_mid]="${h c.sapphire}"
    theme[cpu_end]="${h c.lavender}"
    theme[free_start]="${h c.mauve}"
    theme[free_mid]="${h c.lavender}"
    theme[free_end]="${h c.blue}"
    theme[cached_start]="${h c.sapphire}"
    theme[cached_mid]="${h c.blue}"
    theme[cached_end]="${h c.lavender}"
    theme[available_start]="${h c.peach}"
    theme[available_mid]="${h c.maroon}"
    theme[available_end]="${h c.red}"
    theme[used_start]="${h c.green}"
    theme[used_mid]="${h c.teal}"
    theme[used_end]="${h c.sky}"
    theme[download_start]="${h c.peach}"
    theme[download_mid]="${h c.maroon}"
    theme[download_end]="${h c.red}"
    theme[upload_start]="${h c.green}"
    theme[upload_mid]="${h c.teal}"
    theme[upload_end]="${h c.sky}"
    theme[process_start]="${h c.sapphire}"
    theme[process_mid]="${h c.lavender}"
    theme[process_end]="${h c.mauve}"
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
      pipe = fg c.overlay0;
      block_device = fg c.red;
      char_device = fg c.red;
      socket = fg c.overlay0;
      special = fg c.mauve;
      executable = fg c.green // { is_bold = true; };
      mount_point = fg c.sky;
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
      special_user_file = fg c.mauve;
      special_other = fg c.overlay0;
      attribute = fg c.subtext;
    };
    size = {
      major = fg c.subtext;
      minor = fg c.lavender;
      number_byte = fg c.foreground;
      number_kilo = fg c.foreground;
      number_mega = fg c.sky;
      number_giga = fg c.mauve;
      number_huge = fg c.red;
      unit_byte = fg c.subtext;
      unit_kilo = fg c.sky;
      unit_mega = fg c.mauve;
      unit_giga = fg c.red;
      unit_huge = fg c.peach;
    };
    users = {
      user_you = fg c.foreground;
      user_root = fg c.red;
      user_other = fg c.lavender;
      group_yours = fg c.subtext;
      group_other = fg c.overlay1;
      group_root = fg c.red;
    };
    links = {
      normal = fg c.teal;
      multi_link_file = fg c.sky;
    };
    git = {
      new = fg c.green;
      modified = fg c.yellow;
      deleted = fg c.red;
      renamed = fg c.teal;
      typechange = fg c.pink;
      ignored = fg c.overlay0;
      conflicted = fg c.maroon;
    };
    punctuation = fg c.overlay0;
    date = fg c.pink;
    inode = fg c.subtext;
    blocks = fg c.overlay1;
    header = fg c.foreground;
    octal = fg c.teal;
    symlink_path = fg c.teal;
    control_char = fg c.sky;
    broken_symlink = fg c.red;
  };

  # ---------------- fastfetch ----------------
  # Named colors follow the terminal palette, i.e. Catppuccin Dark.
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
  programs.fzf.colors = {
    "bg+" = h c.surface0;
    bg = h c.background;
    spinner = h c.rosewater;
    hl = h c.red;
    fg = h c.foreground;
    header = h c.red;
    info = h c.mauve;
    pointer = h c.rosewater;
    marker = h c.lavender;
    "fg+" = h c.foreground;
    prompt = h c.mauve;
    "hl+" = h c.red;
    selected-bg = h c.surface1;
    border = h c.overlay0;
  };

  # ---------------- Posting ----------------
  xdg.configFile."posting/config.yaml".text = ''
    theme: catppuccin-dark
  '';
  xdg.dataFile."posting/themes/catppuccin-dark.yaml".text = ''
    name: catppuccin-dark
    primary: "${h c.blue}"
    secondary: "${h c.mauve}"
    accent: "${h c.pink}"
    background: "${h c.background}"
    surface: "${h c.surface0}"
    error: "${h c.red}"
    success: "${h c.green}"
    warning: "${h c.yellow}"
  '';
}
