# Bun pinned to the 1.4 line.
# To bump within 1.4: change `version`, then refresh the four hashes with
#   nix store prefetch-file https://github.com/oven-sh/bun/releases/download/bun-v<ver>/bun-<asset>.zip
{
  bun,
  fetchurl,
  stdenv,
}:
let
  version = "1.4.4";
  assets = {
    x86_64-linux = {
      name = "bun-linux-x64";
      hash = "sha256-v4zL+ysLgBWeD5ptFcVTF63YB3U028YTCj7bUvzLOVw=";
    };
    aarch64-linux = {
      name = "bun-linux-aarch64";
      hash = "sha256-uqa7NvUdblhWHgK76oJQOKnfRU9nPW13bou/hvjHhQ4=";
    };
    aarch64-darwin = {
      name = "bun-darwin-aarch64";
      hash = "sha256-wkDX8My5DCY6hJ/NsJt+5iYw2SE0jtaq/ahrnVd7xRA=";
    };
    x86_64-darwin = {
      name = "bun-darwin-x64";
      hash = "sha256-UKNJH3Orwv6BZzFxqFdi07wswWgMzsrdmD3pmt93l34=";
    };
  };
  asset =
    assets.${stdenv.hostPlatform.system}
      or (throw "bun 1.4: no binary for ${stdenv.hostPlatform.system}");
in
bun.overrideAttrs (old: {
  inherit version;
  src = fetchurl {
    url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/${asset.name}.zip";
    inherit (asset) hash;
  };
  passthru = (old.passthru or { }) // {
    updateScript = null;
  };
})
