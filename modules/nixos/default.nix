# Everything for a standalone NixOS install.
{
  imports = [
    ./core.nix
    ./software.nix
    ./desktop.nix
  ];
}
