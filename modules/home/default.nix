# Home Manager: everything shared by macOS and NixOS.
# tobi/try's Home Manager module is added by lib/default.nix (imports can't
# come from module arguments).
{ config, ... }:
{
  imports = [
    ../options.nix
    ./shell.nix
    ./git.nix
    ./packages.nix
    ./dev-runtimes.nix
    ./neovim.nix
    ./editors.nix
    ./terminals.nix
    ./theme.nix
  ];

  home.username = config.dotfiles.user.name;
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # tobi/try: `try` makes a fresh scratch dir under ~/src/tries and cds into it.
  programs.try.enable = true;
}
