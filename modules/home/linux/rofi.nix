# Rofi launcher ($mod+D), Catppuccin Dark.
{ pkgs, ... }:
let
  c = import ../../palette.nix;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "catppuccin-dark";
    settings = {
      terminal = "foot";
      font = "JetBrainsMono Nerd Font 12";
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = "Yaru-purple-dark";
      drun-display-format = "{name}";
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Windows";
    };
  };

  xdg.dataFile."rofi/themes/catppuccin-dark.rasi".text = ''
    * {
      bg:       #${c.background}e6;
      bg-alt:   #${c.surface0};
      fg:       #${c.foreground};
      fg-dim:   #${c.overlay1};
      accent:   #${c.blue};
      urgent:   #${c.red};

      background-color: transparent;
      text-color: @fg;
      margin: 0;
      padding: 0;
      spacing: 0;
    }

    window {
      width: 600px;
      background-color: @bg;
      border: 1px;
      border-color: @accent;
      border-radius: 8px;
    }

    mainbox { padding: 12px; }

    inputbar {
      padding: 8px 12px;
      spacing: 8px;
      border: 0 0 1px 0;
      border-color: @bg-alt;
      children: [ prompt, entry ];
    }
    prompt { text-color: @accent; }
    entry { placeholder: "Search"; placeholder-color: @fg-dim; }

    listview {
      lines: 8;
      columns: 1;
      fixed-height: false;
      padding: 8px 0 0 0;
    }

    element {
      padding: 6px 12px;
      spacing: 10px;
      border-radius: 6px;
    }
    element normal.urgent, element alternate.urgent { text-color: @urgent; }
    element selected.normal {
      background-color: @bg-alt;
      text-color: @accent;
    }
    element-icon { size: 22px; }
    element-text { text-color: inherit; vertical-align: 0.5; }
  '';
}
