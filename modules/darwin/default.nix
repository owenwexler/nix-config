# nix-darwin: everything for the Mac.
{
  imports = [
    ../options.nix
    ./system.nix
    ./homebrew.nix
    ./services.nix
  ];
}
