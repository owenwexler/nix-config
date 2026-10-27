# Waybar: Omarchy-style layout, Tokyo Night OLED colors.
{ ... }:
let
  c = import ../../palette.nix;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.main = {
      layer = "top";
      position = "top";
      height = 26;
      spacing = 0;

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [
        "tray"
        "bluetooth"
        "network"
        "pulseaudio"
        "cpu"
        "memory"
        "power-profiles-daemon"
        "battery"
      ];

      "hyprland/workspaces" = {
        on-click = "activate";
        format = "{icon}";
        format-icons = {
          default = "";
          active = "󱓻";
        };
        persistent-workspaces."*" = 5;
      };

      clock = {
        format = "{:%a %b %d  %H:%M}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        timezone = "America/New_York";
      };

      tray.spacing = 10;

      bluetooth = {
        format = "";
        format-disabled = "󰂲";
        format-connected = "󰂱";
        tooltip-format = "{device_alias}";
        on-click = "blueman-manager";
      };

      network = {
        format-wifi = "󰤨";
        format-ethernet = "󰀂";
        format-disconnected = "󰤮";
        tooltip-format-wifi = "{essid} ({signalStrength}%)";
        tooltip-format-ethernet = "{ifname} {ipaddr}";
        on-click = "nm-connection-editor";
      };

      pulseaudio = {
        format = "{icon}";
        format-muted = "󰝟";
        format-icons.default = [
          ""
          ""
          ""
        ];
        tooltip-format = "{volume}%";
        on-click = "pavucontrol";
        scroll-step = 5;
      };

      cpu = {
        format = "󰍛 {usage}%";
        interval = 5;
        on-click = "foot btop";
      };

      memory = {
        format = " {}%";
        interval = 10;
      };

      power-profiles-daemon = {
        format = "{icon}";
        tooltip-format = "Power profile: {profile}";
        format-icons = {
          default = "";
          performance = "";
          balanced = "";
          power-saver = "";
        };
      };

      battery = {
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-icons = [
          "󰁺"
          "󰁼"
          "󰁾"
          "󰂀"
          "󰁹"
        ];
        states = {
          warning = 20;
          critical = 10;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: #${c.background};
        color: #${c.foreground};
      }

      #workspaces button {
        padding: 0 6px;
        color: #${c.muted};
        background: transparent;
      }
      #workspaces button.active { color: #${c.blue}; }
      #workspaces button.urgent { color: #${c.red}; }
      #workspaces button:hover {
        background: #${c.surface};
        box-shadow: none;
      }

      #clock { color: #${c.foreground}; }

      #tray, #bluetooth, #network, #pulseaudio, #cpu, #memory,
      #power-profiles-daemon, #battery {
        padding: 0 8px;
        color: #${c.foreground};
      }

      #network.disconnected, #pulseaudio.muted { color: #${c.comment}; }
      #battery.charging { color: #${c.green}; }
      #battery.warning:not(.charging) { color: #${c.yellow}; }
      #battery.critical:not(.charging) { color: #${c.red}; }

      tooltip {
        background: #${c.background};
        border: 1px solid #${c.blue};
      }
      tooltip label { color: #${c.foreground}; }
    '';
  };
}
