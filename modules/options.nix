# Options shared by the NixOS, nix-darwin and Home Manager modules.
# Values come from settings.nix (see lib/default.nix), or set them yourself
# when importing these modules into another flake.
{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
  group = description: mkEnableOption description // { default = true; };
in
{
  options.dotfiles = {
    user = {
      name = mkOption {
        type = types.str;
        description = "Login name of the main user.";
      };
      fullName = mkOption {
        type = types.str;
        description = "Full name, used for git.";
      };
      email = mkOption {
        type = types.str;
        description = "E-mail, used for git.";
      };
    };

    timeZone = mkOption {
      type = types.str;
      default = "America/New_York";
    };

    macKeyboard = mkOption {
      type = types.bool;
      default = false;
      description = ''
        NixOS on an Apple keyboard: swap Option and Command so $mod (Super)
        is the physical Option key, matching Hyper on macOS.
      '';
    };

    # Software groups. All on by default; turn one off to slim a machine down.
    software = {
      gaming = group "Steam and RetroArch";
      gameDev = group "Godot, Tiled, Krita, GIMP, Audacity, LMMS, Blender";
      videoEditing = group "Video editing apps";
      mobileDev = group "Android Studio and iOS tooling";
      kotlinDev = group "JDK 21, Gradle, Kotlin, IntelliJ";
      remoteGui = group "RDP/VNC/Moonlight/Sunshine and friends";
      virtualMachines = group "Parallels/UTM on macOS, QEMU/virt-manager on NixOS";
      ai = group "Claude Code, Codex, OpenCode, Grok Build, Ollama";
    };
  };
}
