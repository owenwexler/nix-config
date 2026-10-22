# Apps and services for NixOS. This module doesn't touch the desktop, so it
# can be imported next to Nixarchy (which brings its own Hyprland setup) or
# into any other NixOS config. CLI tools come from the Home Manager modules.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  sw = config.dotfiles.software;
  user = config.dotfiles.user.name;
  inherit (lib) mkIf optionals;
in
{
  imports = [ ../options.nix ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    with pkgs;
    [
      # ---- Browser, terminals, files ----
      chromium
      foot
      kitty
      nautilus

      # ---- Misc apps ----
      zoom-us
      slack
      spotify
      dropbox
      dbeaver-bin # TablePlus has no NixOS build; DBeaver is the closest match
      nordvpn

      # ---- Editors ----
      vscode
      zed-editor

      # ---- Remote dev / GUI ----
      waypipe # macOS equivalent: XQuartz (ssh -X)
      xauth
    ]
    ++ optionals sw.remoteGui [
      freerdp
      remmina
      tigervnc
      wayvnc
      moonlight-qt
    ]
    ++ optionals sw.mobileDev [
      android-studio
      libimobiledevice
    ]
    ++ optionals sw.kotlinDev [
      jetbrains.idea # IntelliJ IDEA (the free tier replaced Community Edition)
    ]
    ++ optionals sw.gameDev [
      godot-mono # Godot 4 with C#/.NET support
      tiled
      krita
      gimp
      audacity
      lmms
      blender
    ]
    ++ optionals sw.videoEditing [
      kdePackages.kdenlive
      shotcut
      davinci-resolve
      handbrake
      mpv
      # Adobe Creative Cloud has no Linux version.
    ]
    ++ optionals sw.gaming [
      (retroarch.withCores (
        cores: with cores; [
          dosbox-pure # DOS abandonware
          beetle-psx-hw # PlayStation
          snes9x # SNES
          nestopia # NES
          genesis-plus-gx # Mega Drive / Master System / Game Gear
          gambatte # Game Boy / Game Boy Color
          mgba # Game Boy Advance
          melondsds # DS
          citra # 3DS
          mupen64plus # N64
          flycast # Dreamcast
          ppsspp # PSP
          mame # MAME / arcade
          fbneo # arcade (lighter alternative to MAME)
        ]
      ))
      azahar # standalone 3DS emulator, for games the libretro core struggles with
    ]
    ++ optionals sw.virtualMachines [
      # Parallels and UTM are macOS-only; QEMU/KVM + virt-manager covers both.
      virt-manager
      quickemu
    ];

  # Prebuilt binaries (Mason LSPs in LazyVim, Bun/Deno add-ons, Grok Build)
  # expect a normal Linux loader. nix-ld provides one.
  programs.nix-ld.enable = true;

  # ---- Services ----
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ user ];
  };

  services.tailscale.enable = true;

  services.nordvpn.enable = true;

  virtualisation.docker.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    # A superuser role and database named after you, so `psql -d postgres`
    # (the `pg` alias) works without `sudo -u postgres`.
    ensureUsers = [
      {
        name = user;
        ensureClauses.superuser = true;
      }
    ];
    ensureDatabases = [ user ];
  };

  services.redis.servers."".enable = true;

  services.ollama.enable = sw.ai;

  services.sunshine = mkIf sw.remoteGui {
    enable = true;
    autoStart = false; # start it when you want to stream: systemctl --user start sunshine
    capSysAdmin = true;
    openFirewall = true;
  };

  programs.steam = mkIf sw.gaming {
    enable = true;
    remotePlay.openFirewall = true;
  };

  virtualisation.libvirtd.enable = sw.virtualMachines;
  programs.virt-manager.enable = sw.virtualMachines;

  users.users.${user}.extraGroups = [
    "docker"
    "nordvpn"
  ]
  ++ optionals sw.virtualMachines [ "libvirtd" ]
  ++ optionals sw.mobileDev [ "adbusers" ];
}
