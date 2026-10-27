# Aerospace (tiling), JankyBorders, SketchyBar, Postgres, Redis, and the
# Try Omarchy app.
#
# $mod is Hyper (Shift+Cmd+Ctrl+Opt) on the physical Left Option key, set up
# by Karabiner (modules/home/darwin/karabiner.nix). Hyper already contains
# Shift, so "$mod+Shift+key" can't be told apart from "$mod+key" by Shift
# alone. Karabiner solves that: Hyper + physical Shift + key is sent as
# Cmd+Ctrl+Opt+key (no Shift). In Aerospace terms:
#   $mod+key        = cmd-alt-ctrl-shift-<key>
#   $mod+Shift+key  = cmd-alt-ctrl-<key>
{
  config,
  lib,
  pkgs,
  ...
}:
let
  c = import ../palette.nix;
  sw = config.dotfiles.software;
  user = config.dotfiles.user.name;
  mod = "cmd-alt-ctrl-shift";
  modShift = "cmd-alt-ctrl";

  # Ghostty is single-instance on macOS: activate it and ask for a new window.
  newTerminal = pkgs.writeShellScript "ghostty-new-window" ''
    if pgrep -xq ghostty; then
      osascript -e 'tell application "Ghostty" to activate' \
        -e 'tell application "System Events" to keystroke "n" using command down'
    else
      open -a Ghostty
    fi
  '';

  workspaces = map toString (lib.range 1 9);
  forWorkspaces = f: lib.listToAttrs (map f workspaces);
in
{
  # ---------------- Aerospace ----------------
  services.aerospace = {
    enable = true;
    settings = {
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      persistent-workspaces = workspaces;

      # Tight gaps like Hyprland. The top gap leaves room for SketchyBar.
      gaps = {
        inner.horizontal = 3;
        inner.vertical = 3;
        outer.left = 3;
        outer.right = 3;
        outer.top = 36;
        outer.bottom = 3;
      };

      key-mapping.preset = "qwerty";

      # Tell SketchyBar which workspace is focused.
      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      mode.main.binding = {
        # ---- Apps (NIX_SETUP.md shortcuts) ----
        "${mod}-d" = "exec-and-forget open -a Raycast";
        "${mod}-enter" = "exec-and-forget ${newTerminal}";
        "${modShift}-enter" = "exec-and-forget open -na kitty";
        "${mod}-b" = "exec-and-forget open -na Chromium --args --new-window";
        "${mod}-e" = "exec-and-forget open ~";
        "${mod}-p" = ''exec-and-forget open -a "Parallels Desktop"'';
        "${mod}-o" = ''exec-and-forget open -a "Try Omarchy"'';

        # ---- Focus / move (vim keys) ----
        "${mod}-h" = "focus left";
        "${mod}-j" = "focus down";
        "${mod}-k" = "focus up";
        "${mod}-l" = "focus right";
        "${modShift}-h" = "move left";
        "${modShift}-j" = "move down";
        "${modShift}-k" = "move up";
        "${modShift}-l" = "move right";

        # ---- Windows ----
        "${modShift}-q" = "close";
        "${mod}-f" = "fullscreen";
        "${modShift}-space" = "layout floating tiling";
        "${mod}-minus" = "resize smart -50";
        "${mod}-equal" = "resize smart +50";
        "${mod}-slash" = "layout tiles horizontal vertical";
        "${mod}-comma" = "layout accordion horizontal vertical";

        # ---- Workspaces ----
        "${mod}-tab" = "workspace-back-and-forth";
        "${modShift}-semicolon" = "mode service";
      }
      // forWorkspaces (ws: lib.nameValuePair "${mod}-${ws}" "workspace ${ws}")
      // forWorkspaces (ws: lib.nameValuePair "${modShift}-${ws}" "move-node-to-workspace ${ws}");

      mode.service.binding = {
        esc = [
          "reload-config"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ];
        f = [
          "layout floating tiling"
          "mode main"
        ];
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];
        h = [
          "join-with left"
          "mode main"
        ];
        j = [
          "join-with down"
          "mode main"
        ];
        k = [
          "join-with up"
          "mode main"
        ];
        l = [
          "join-with right"
          "mode main"
        ];
      };

      # Float the apps that make poor tiles.
      on-window-detected = [
        {
          "if".app-id = "com.raycast.macos";
          run = "layout floating";
        }
        {
          "if".app-id = "com.1password.1password";
          run = "layout floating";
        }
        {
          "if".app-id = "com.apple.systempreferences";
          run = "layout floating";
        }
      ];
    };
  };

  # ---------------- JankyBorders ----------------
  services.jankyborders = {
    enable = true;
    style = "round";
    width = 3.0;
    hidpi = true;
    active_color = "gradient(top_left=0xee${c.blue},bottom_right=0xee${c.magenta})";
    inactive_color = "0x00000000";
  };

  # ---------------- SketchyBar (config in modules/home/darwin) ----------------
  services.sketchybar = {
    enable = true;
    extraPackages = [ pkgs.aerospace ];
  };

  # ---------------- Databases ----------------
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
  };

  services.redis.enable = true;

  # ---------------- Apps that aren't casks ----------------
  system.activationScripts.postActivation.text = lib.mkAfter ''
    # Try Omarchy (Apple Silicon only): Omarchy in a VM. Installed once from
    # the GitHub release; it keeps itself up to date after that.
    if [ "$(uname -m)" = arm64 ] && ! ls -d /Applications/*Omarchy*.app >/dev/null 2>&1; then
      echo "Installing Try Omarchy..."
      tmp=$(mktemp -d)
      if curl -fsSL -o "$tmp/TryOmarchy.dmg" \
          https://github.com/omacom/try-omarchy/releases/latest/download/TryOmarchy.dmg \
        && hdiutil attach -nobrowse -quiet -mountpoint "$tmp/mnt" "$tmp/TryOmarchy.dmg"; then
        cp -R "$tmp"/mnt/*.app /Applications/ || echo "Try Omarchy: copy failed" >&2
        hdiutil detach -quiet "$tmp/mnt"
      else
        echo "Try Omarchy: download failed; re-run darwin-rebuild to retry" >&2
      fi
      rm -rf "$tmp"
    fi

    ${lib.optionalString sw.mobileDev ''
      # iOS simulator runtime, once Xcode is installed and its license accepted.
      if [ -d /Applications/Xcode.app ] && ! xcrun simctl list runtimes 2>/dev/null | grep -q iOS; then
        echo "Downloading the iOS simulator runtime (one-time, several GB)..."
        sudo -u ${user} xcodebuild -downloadPlatform iOS || echo "iOS simulator download failed; run: xcodebuild -downloadPlatform iOS" >&2
      fi
    ''}
  '';
}
