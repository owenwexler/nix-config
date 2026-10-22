# Hyprland desktop for a standalone NixOS install (Waybar, Rofi, Mako,
# Hyprlock/Hypridle, greetd login). Skip this module when using Nixarchy.
# The user-side dotfiles are in modules/home/linux.
{ pkgs, ... }:
{
  imports = [ ../options.nix ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # PAM for the lock screen. Hypridle itself runs from Home Manager.
  programs.hyprlock.enable = true;

  # Text login screen that starts Hyprland.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd 'uwsm start hyprland-uwsm.desktop'";
      user = "greeter";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Chromium/Electron apps run natively on Wayland
    TERMINAL = "foot";
  };

  environment.systemPackages = with pkgs; [
    waybar
    rofi
    mako
    swaybg
    swayosd
    hyprpicker
    hyprpolkitagent
    hyprshot
    cliphist
    wl-clipboard
    grim
    slurp
    satty
    wf-recorder
    brightnessctl
    playerctl
    pamixer
    pavucontrol
    networkmanagerapplet
    blueman
    adw-gtk3
    yaru-theme
    bibata-cursors
    xdg-utils
  ];

  # Audio, Bluetooth, power, disks, keyring
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true; # Nautilus trash, network shares, phones
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
