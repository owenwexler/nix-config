# Home Manager dotfiles for the standalone NixOS Hyprland desktop.
# Pairs with modules/nixos/desktop.nix. Leave it out when using Nixarchy.
{
  imports = [
    ../../options.nix
    ./hyprland.nix
    ./waybar.nix
    ./rofi.nix
    ./desktop.nix
  ];
}
