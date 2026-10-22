# Mac GUI apps come from Homebrew casks: they land in /Applications, so
# Raycast/Spotlight find them and they update themselves. CLI tools come from
# Nix (modules/home/packages.nix).
{ config, lib, ... }:
let
  sw = config.dotfiles.software;
  inherit (lib) optionals;
in
{
  # Installs Homebrew itself (fresh install friendly).
  nix-homebrew = {
    enable = true;
    user = config.dotfiles.user.name;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # Leaves anything you installed by hand alone. Switch to "zap" to make
      # this list the only source of truth.
      cleanup = "none";
    };

    taps = [
      "gromgit/fuse" # sshfs for macOS
      "lizardbyte/homebrew" # Sunshine
    ];

    brews = [
      "mas" # Mac App Store CLI, used for masApps below
    ]
    ++ optionals sw.remoteGui [ "lizardbyte/homebrew/sunshine" ]
    ++ [ "gromgit/fuse/sshfs-mac" ];

    casks = [
      # ---- Desktop: keyboard, launcher, bar ----
      "karabiner-elements"
      "raycast"
      "stats"

      # ---- Terminals, browser ----
      "ghostty"
      "kitty"
      "chromium"

      # ---- Misc ----
      "nordvpn"
      "1password"
      "1password-cli"
      "zoom"
      "slack"
      "spotify"
      "dropbox"
      "tableplus"

      # ---- Editors ----
      "visual-studio-code"
      "zed"

      # ---- Remote dev / GUI ----
      "tailscale-app"
      "docker-desktop" # Docker + docker compose
      "macfuse" # needed by sshfs
      "xquartz" # the macOS stand-in for waypipe: X11 forwarding with ssh -X
    ]
    ++ optionals sw.remoteGui [
      "windows-app" # Microsoft's RDP client (macOS side of FreeRDP/Remmina)
      "tigervnc-viewer"
      "moonlight"
    ]
    ++ optionals sw.mobileDev [
      "android-studio"
      "android-commandlinetools"
    ]
    ++ optionals sw.kotlinDev [ "intellij-idea-ce" ]
    ++ optionals sw.gameDev [
      "godot-mono"
      "tiled"
      "krita"
      "gimp"
      "audacity"
      "lmms"
      "blender"
    ]
    ++ optionals sw.videoEditing [
      "adobe-creative-cloud"
      "handbrake-app"
      "stolendata-mpv"
    ]
    ++ optionals sw.gaming [
      "steam"
      "retroarch-metal" # cores: Main Menu > Online Updater > Core Downloader
    ]
    ++ optionals sw.virtualMachines [
      "parallels"
      "utm"
    ]
    ++ optionals sw.ai [ "ollama-app" ];

    # Sign in to the App Store before the first switch, or these fail.
    masApps =
      lib.optionalAttrs sw.mobileDev { Xcode = 497799835; }
      // lib.optionalAttrs sw.videoEditing { "DaVinci Resolve" = 571213070; };
  };
}
