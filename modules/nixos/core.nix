# Base system: Nix itself, time zone, locale, the user account, fonts.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  user = config.dotfiles.user.name;
  passwordFile = config.dotfiles.user.passwordFile;
in
{
  imports = [ ../options.nix ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        user
      ];
      auto-optimise-store = true;
      # Ride out flaky connections (VM NAT, cache.nixos.org timeouts) instead
      # of failing a big rebuild halfway through.
      download-attempts = 10;
      connect-timeout = 30;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = config.dotfiles.timeZone;
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    description = config.dotfiles.user.fullName;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
    hashedPasswordFile = passwordFile;
  };

  # Refuse to switch if the password file is missing; otherwise the user
  # would be created with no password and you'd be locked out.
  system.preSwitchChecks.passwordFile = lib.mkIf (passwordFile != null) ''
    if [ ! -s ${lib.escapeShellArg passwordFile} ]; then
      echo "Missing ${passwordFile}. Create it first (see README.md):" >&2
      echo "  nix-shell -p mkpasswd --run 'mkpasswd -m sha-512' | sudo tee ${passwordFile} > /dev/null" >&2
      exit 1
    fi
  '';

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
  ];

  fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];

  system.stateVersion = "26.05";
}
