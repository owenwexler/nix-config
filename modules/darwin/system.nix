# macOS settings from NIX_SETUP.md: no desktop items or widgets, a hidden
# dock, Finder preferences, auto-hidden menu bar, Spotlight off Cmd+Space.
{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  user = config.dotfiles.user.name;
in
{
  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      user
    ];
  };
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };
  nix.optimise.automatic = true;

  nixpkgs.config.allowUnfree = true;

  # Share the system package set (and its allowUnfree) with Home Manager.
  # See modules/nixos/software.nix.
  home-manager = lib.optionalAttrs (options ? home-manager) {
    useGlobalPkgs = lib.mkDefault true;
  };

  programs.zsh.enable = true;

  time.timeZone = config.dotfiles.timeZone;

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    # ---- Desktop & Stage Manager: show nothing, no widgets ----
    finder.CreateDesktop = false;
    WindowManager = {
      StandardHideDesktopIcons = true;
      HideDesktop = true;
      StandardHideWidgets = true;
      StageManagerHideWidgets = true;
      EnableStandardClickToShowDesktop = false;
    };

    # ---- Dock: empty, tiny, on the left, auto-hidden, no animations ----
    dock = {
      persistent-apps = [ ];
      persistent-others = [ ];
      show-recents = false;
      tilesize = 16;
      orientation = "left";
      autohide = true;
      launchanim = false;
      static-only = true; # only running apps; nothing pinned
      mru-spaces = false; # Aerospace needs Spaces in a fixed order
      expose-group-apps = true; # Aerospace recommendation for Mission Control
    };

    # ---- Finder ----
    finder = {
      ShowExternalHardDrivesOnDesktop = false;
      ShowHardDrivesOnDesktop = false;
      ShowMountedServersOnDesktop = false;
      ShowRemovableMediaOnDesktop = false;
      NewWindowTarget = "Home";
      FXPreferredViewStyle = "Nlsv"; # list view
      FXEnableExtensionChangeWarning = false;
      FXDefaultSearchScope = "SCcf"; # search the current folder
      ShowPathbar = true;
      ShowStatusBar = true;
      AppleShowAllExtensions = true;
    };

    # ---- Menu bar: auto-hide (SketchyBar takes its place) ----
    NSGlobalDomain = {
      _HIHideMenuBar = true;
      AppleInterfaceStyle = "Dark";
      NSAutomaticWindowAnimationsEnabled = false;
    };

    CustomUserPreferences = {
      "com.apple.finder" = {
        FinderSpawnTab = true; # open folders in tabs, not new windows
        ShowRecentTags = false; # nothing under Tags
        FavoriteTagNames = [ ];
        _FXSortFoldersFirst = true;
      };

      # Free Cmd+Space for Raycast: turn off Spotlight's two shortcuts
      # (64 = show Spotlight search, 65 = Finder search window).
      "com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
        "64" = {
          enabled = false;
          value = {
            type = "standard";
            parameters = [
              32
              49
              1048576 # Cmd+Space
            ];
          };
        };
        "65" = {
          enabled = false;
          value = {
            type = "standard";
            parameters = [
              32
              49
              1572864 # Cmd+Opt+Space
            ];
          };
        };
      };

      # Liquid Glass: Appearance > "Tint window background with wallpaper
      # color" off. (Reduce Transparency is set below the defaults.)
      NSGlobalDomain.AppleReduceDesktopTinting = true;

      # Don't write .DS_Store on network and USB volumes
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };

  # Liquid Glass: Accessibility > Display > Reduce Transparency.
  # macOS only lets a process write this domain if it has Full Disk Access,
  # so a failure warns instead of aborting the switch.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    sudo -u ${user} defaults write com.apple.universalaccess reduceTransparency -bool true \
      || echo "Couldn't set Reduce Transparency. Turn it on in System Settings > Accessibility > Display, or give your terminal Full Disk Access and re-run the switch." >&2
  '';

  system.stateVersion = 6;
}
