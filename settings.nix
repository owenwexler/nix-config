# Personal values used by the two hosts in this flake.
# Edit these before the first install (hostnames especially).
{
  username = "owenwexler";
  fullName = "Owen Wexler";
  email = "owenbwexler@gmail.com";
  timeZone = "America/New_York";

  nixos = {
    hostname = "nixos";
    # ARM, for the Parallels VM on Apple Silicon. Use "x86_64-linux" on Intel/AMD.
    # Apps with no ARM Linux build (Zoom, Slack, Spotify, Steam...) are skipped
    # with a warning; see lib/available.nix.
    system = "aarch64-linux";
    # Set true on Apple keyboards: swaps Option/Command so $mod (Super)
    # sits on the physical Option key, same spot as Hyper on macOS.
    macKeyboard = false;
    # Your hashed password, kept outside the repo so a rebuild can never leave
    # you without one. Create it before the first switch; see README.md.
    passwordFile = "/etc/nixos/user-password.txt";
  };

  # Apple Silicon Mac (M4), on nixpkgs-unstable.
  darwin = {
    hostname = "macbook";
    system = "aarch64-darwin";
  };

  # Intel Mac (2019 MacBook Pro). nixpkgs-unstable dropped Intel Macs, so this
  # one uses the 26.05 branches, which get updates until the end of 2026.
  darwinIntel = {
    hostname = "macbook-intel";
    system = "x86_64-darwin";
  };
}
