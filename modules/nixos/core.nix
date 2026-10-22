# Base system: Nix itself, time zone, locale, the user account, fonts.
{
  config,
  pkgs,
  ...
}:
let
  user = config.dotfiles.user.name;
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
  };

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
