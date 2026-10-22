# Bun pinned to the 1.4 line.
# To bump within 1.4: change `version`, then refresh the four hashes with
#   nix store prefetch-file https://github.com/oven-sh/bun/releases/download/bun-v<ver>/bun-<asset>.zip
{
  bun,
  fetchurl,
  stdenv,
}:
let
  version = "1.4.3";
  assets = {
    x86_64-linux = {
      name = "bun-linux-x64";
      hash = "sha256-PnMFKNiXdfA/h/BcBnh8TfQJnQo38/JS57gpyyOBbhg=";
    };
    aarch64-linux = {
      name = "bun-linux-aarch64";
      hash = "sha256-76mBPaXtckI7+Ef5FujSxHwNd2rdlyNUAmp14Q2pqiE=";
    };
    aarch64-darwin = {
      name = "bun-darwin-aarch64";
      hash = "sha256-gK/UwGm0am+o8+xSC+vHUKeEPkqNW5WD0prUNsAKNAM=";
    };
    x86_64-darwin = {
      name = "bun-darwin-x64";
      hash = "sha256-YmYOZDjrhyJ4h3rMp34RUtXQMTJN82jUqBtCghFInS0=";
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
