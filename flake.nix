{
  description = "Owen's NixOS (Hyprland) + macOS (nix-darwin) setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Intel Macs: nixpkgs 26.05 is the last release that supports x86_64-darwin
    # (security updates until the end of 2026). Only #macbook-intel uses these.
    nixpkgs-intel.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin-intel = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-intel";
    };
    home-manager-intel = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-intel";
    };

    # Installs and pins Homebrew itself, so casks can be managed declaratively.
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # tobi/try. Not the same as nixpkgs' `try`, which is an unrelated tool.
    try = {
      url = "github:tobi/try";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cliamp = {
      url = "github:bjarneo/cliamp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      settings = import ./settings.nix;
      lib = import ./lib { inherit inputs settings; };
    in
    {
      # ---------------------------------------------------------------
      # Main configurations
      # ---------------------------------------------------------------
      # sudo nixos-rebuild switch --flake ./nix#nixos
      nixosConfigurations.${settings.nixos.hostname} = lib.mkNixos {
        hostModule = ./hosts/nixos;
      };

      # sudo darwin-rebuild switch --flake ./nix#macbook
      darwinConfigurations.${settings.darwin.hostname} = lib.mkDarwin {
        hostModule = ./hosts/macbook;
      };

      # sudo darwin-rebuild switch --flake ./nix#macbook-intel
      darwinConfigurations.${settings.darwinIntel.hostname} = lib.mkDarwin {
        hostModule = ./hosts/macbook-intel;
        host = settings.darwinIntel;
        darwin = inputs.nix-darwin-intel;
        homeManager = inputs.home-manager-intel;
      };

      # ---------------------------------------------------------------
      # Reusable modules: plug these into another NixOS setup (a custom
      # scaffold, or Nixarchy). See README.md for examples.
      # ---------------------------------------------------------------
      nixosModules = builtins.mapAttrs (_: lib.withInputs) {
        # Software and services only. Safe next to Nixarchy, which brings
        # its own Hyprland desktop.
        software = ./modules/nixos/software.nix;
        # Base system: time zone, locale, user, fonts, nix settings.
        core = ./modules/nixos/core.nix;
        # Hyprland + Waybar + Rofi desktop. Only for a standalone install.
        desktop = ./modules/nixos/desktop.nix;
        default = ./modules/nixos;
      };

      darwinModules.default = lib.withInputs ./modules/darwin;

      homeModules = {
        # Shell, git, CLI tools, editors, themes. Works on macOS and Linux.
        common = lib.homeCommon;
      }
      // builtins.mapAttrs (_: lib.withInputs) {
        # Hyprland, Waybar, Rofi, Foot, GTK dotfiles. Standalone NixOS only.
        hyprland = ./modules/home/linux;
        # Aerospace, SketchyBar, Ghostty, Karabiner dotfiles.
        darwin = ./modules/home/darwin;
      };

      overlays.default = import ./pkgs/overlay.nix;
    };
}
