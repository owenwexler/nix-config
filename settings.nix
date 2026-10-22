# Personal values used by the two hosts in this flake.
# Edit these before the first install (hostnames especially).
{
  username = "owenwexler";
  fullName = "Owen Wexler";
  email = "owenbwexler@gmail.com";
  timeZone = "America/New_York";

  nixos = {
    hostname = "nixos";
    system = "x86_64-linux"; # "aarch64-linux" on ARM hardware
    # Set true on Apple keyboards: swaps Option/Command so $mod (Super)
    # sits on the physical Option key, same spot as Hyper on macOS.
    macKeyboard = false;
  };

  darwin = {
    hostname = "macbook";
    # nixpkgs-unstable no longer supports Intel Macs (x86_64-darwin).
    system = "aarch64-darwin";
  };
}
