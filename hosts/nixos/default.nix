# The NixOS machine. Everything else comes from modules/nixos and modules/home.
#
# Before the first `nixos-rebuild`, copy this machine's hardware config here:
#   cp /etc/nixos/hardware-configuration.nix ~/dotfiles/nix/hosts/nixos/
#   git -C ~/dotfiles add nix/hosts/nixos/hardware-configuration.nix
{ lib, ... }:
let
  hardware = ./hardware-configuration.nix;
  haveHardware = builtins.pathExists hardware;
in
{
  imports = lib.optional haveHardware hardware;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Stand-in so the flake still evaluates before hardware-configuration.nix
  # exists. Never boot with this.
  fileSystems = lib.mkIf (!haveHardware) {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };
  warnings = lib.optional (!haveHardware) ''
    hosts/nixos/hardware-configuration.nix is missing; using a placeholder.
    Copy /etc/nixos/hardware-configuration.nix there (and git add it) before switching.
  '';
}
