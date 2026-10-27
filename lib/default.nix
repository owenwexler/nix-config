# Helpers that assemble the two main systems from the reusable modules.
{ inputs, settings }:
let
  inherit (inputs)
    nixpkgs
    home-manager
    nix-darwin
    nix-homebrew
    ;

  # Gives every module a `flakeInputs` argument. The `key` makes the module
  # system load this only once, however many of our modules import it.
  inputsModule = {
    key = "dotfiles#flake-inputs";
    _module.args.flakeInputs = inputs;
  };

  withInputs = path: {
    imports = [
      inputsModule
      path
    ];
  };

  # Shared Home Manager config, plus tobi/try's module (which it enables).
  homeCommon = {
    imports = [
      inputsModule
      ../modules/home
      inputs.try.homeModules.default
    ];
  };

  # The values from settings.nix, as `dotfiles.*` options. Shared by the
  # system and Home Manager.
  settingsModule = {
    dotfiles = {
      user = {
        name = settings.username;
        fullName = settings.fullName;
        email = settings.email;
        passwordFile = settings.nixos.passwordFile;
      };
      timeZone = settings.timeZone;
      macKeyboard = settings.nixos.macKeyboard;
    };
  };

  homeManager = platformModule: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      # A pre-existing file (e.g. a stock ~/.zshrc) is renamed, not clobbered.
      backupFileExtension = "hm-backup";
      users.${settings.username}.imports = [
        settingsModule
        homeCommon
        (withInputs platformModule)
      ];
    };
  };
in
{
  inherit withInputs homeCommon;

  mkNixos =
    { hostModule }:
    nixpkgs.lib.nixosSystem {
      modules = [
        {
          nixpkgs.hostPlatform = settings.nixos.system;
          nixpkgs.config.allowUnfree = true;
          networking.hostName = settings.nixos.hostname;
        }
        settingsModule
        (withInputs ../modules/nixos)
        home-manager.nixosModules.home-manager
        (homeManager ../modules/home/linux)
        hostModule
      ];
    };

  # `host`, `darwin` and `homeManager` are swapped for the Intel Mac, which
  # needs the 26.05 branches (see flake.nix).
  mkDarwin =
    {
      hostModule,
      host ? settings.darwin,
      darwin ? nix-darwin,
      homeManager ? home-manager,
    }:
    darwin.lib.darwinSystem {
      modules = [
        {
          nixpkgs.hostPlatform = host.system;
          nixpkgs.config.allowUnfree = true;
          networking.hostName = host.hostname;
          networking.computerName = host.hostname;
        }
        settingsModule
        (withInputs ../modules/darwin)
        homeManager.darwinModules.home-manager
        nix-homebrew.darwinModules.nix-homebrew
        (homeManager ../modules/home/darwin)
        hostModule
      ];
    };
}
