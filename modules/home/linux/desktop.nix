# The rest of the Linux desktop: Foot, GTK/Nautilus theme, cursor,
# notifications, OSD, clipboard history, lock screen, idle.
{ lib, pkgs, ... }:
let
  c = import ../../palette.nix;
  ansi = lib.listToAttrs (
    lib.imap0 (
      i: hex:
      lib.nameValuePair (if i < 8 then "regular${toString i}" else "bright${toString (i - 8)}") hex
    ) c.ansi
  );
in
{
  # ---------------- Foot (main terminal) ----------------
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        pad = "6x6";
      };
      mouse.hide-when-typing = "yes";
      colors-dark = {
        background = c.background;
        foreground = c.foreground;
        selection-background = c.rosewater;
        selection-foreground = c.background;
        cursor = "${c.background} ${c.cursor}";
        urls = c.blue;
      }
      // ansi;
    };
  };

  # ---------------- GTK (Nautilus) ----------------
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Yaru-purple-dark";
      package = pkgs.yaru-theme;
    };
    font = {
      name = "Noto Sans";
      size = 11;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    # libadwaita (Nautilus and other GTK4 apps) picks these colors up.
    gtk4.extraCss = ''
      @define-color accent_color #${c.blue};
      @define-color accent_bg_color #${c.blue};
      @define-color accent_fg_color #${c.background};
      @define-color window_bg_color #${c.background};
      @define-color window_fg_color #${c.foreground};
      @define-color view_bg_color #${c.background};
      @define-color view_fg_color #${c.foreground};
      @define-color headerbar_bg_color #${c.background};
      @define-color headerbar_fg_color #${c.foreground};
      @define-color sidebar_bg_color #${c.surface0};
      @define-color sidebar_fg_color #${c.foreground};
      @define-color card_bg_color #${c.surface0};
      @define-color card_fg_color #${c.foreground};
      @define-color popover_bg_color #${c.surface0};
      @define-color popover_fg_color #${c.foreground};
      @define-color dialog_bg_color #${c.surface0};
      @define-color dialog_fg_color #${c.foreground};
      @define-color destructive_bg_color #${c.red};
      @define-color success_color #${c.green};
      @define-color warning_color #${c.yellow};
      @define-color error_color #${c.red};
    '';
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  # Nautilus as the default file manager
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "text/html" = "chromium-browser.desktop";
      "x-scheme-handler/http" = "chromium-browser.desktop";
      "x-scheme-handler/https" = "chromium-browser.desktop";
    };
  };

  # ---------------- Background services ----------------
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 11";
      background-color = "#${c.background}e6";
      text-color = "#${c.foreground}";
      border-color = "#${c.blue}";
      border-size = 1;
      border-radius = 4;
      padding = "16,20";
      default-timeout = 5000;
    };
  };

  services.swayosd.enable = true;
  services.cliphist.enable = true;
  services.hyprpolkitagent.enable = true;

  # ---------------- Lock + idle ----------------
  programs.hyprlock = {
    enable = true;
    settings = {
      general.hide_cursor = true;
      background = [
        {
          color = "rgb(${c.background})";
        }
      ];
      input-field = [
        {
          size = "600, 80";
          position = "0, 0";
          halign = "center";
          valign = "center";
          outer_color = "rgb(${c.blue})";
          inner_color = "rgb(${c.background})";
          font_color = "rgb(${c.foreground})";
          check_color = "rgb(${c.teal})";
          fail_color = "rgb(${c.red})";
          placeholder_text = "Enter password";
          rounding = 4;
          outline_thickness = 2;
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"on\" })'";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"off\" })'";
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"on\" })'";
        }
      ];
    };
  };
}
