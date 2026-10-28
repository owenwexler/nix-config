# Node pinned to the 24 line, from nodejs.org's official binaries rather than
# nixpkgs' `nodejs_24`, so security fixes land without waiting for nixpkgs
# (24.22.1 fixes Node2Shell, CVE-2026-111497; nixpkgs was still on 24.21.0).
# Once nixpkgs' nodejs_24 catches up, this can go back to plain `nodejs_24`.
# To bump: change `version`, then take the four hashes from
#   https://nodejs.org/dist/v<ver>/SHASUMS256.txt (hex -> base64 for SRI)
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
let
  version = "24.22.1";
  assets = {
    x86_64-linux = {
      name = "linux-x64";
      hash = "sha256-bBcqmrZxj3uAH7WnvUhq8u5eMnWAhqBLhPzOKqdwleY=";
    };
    aarch64-linux = {
      name = "linux-arm64";
      hash = "sha256-26v3ocv5R+YFn/rSwnuABB25feoeVTtir97n8T/KM24=";
    };
    aarch64-darwin = {
      name = "darwin-arm64";
      hash = "sha256-ZUunneYVVkfiIyGTK0Xyocy3BZdswzfJuOJ4vrCFpig=";
    };
    x86_64-darwin = {
      name = "darwin-x64";
      hash = "sha256-ZeRQ+Qpuqs1QAPYRhhxM5l+tyH+BN5XcTtDA5fL8otQ=";
    };
  };
  asset =
    assets.${stdenv.hostPlatform.system}
      or (throw "node 24: no binary for ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "nodejs";
  inherit version;
  src = fetchurl {
    url = "https://nodejs.org/dist/v${version}/node-v${version}-${asset.name}.tar.xz";
    inherit (asset) hash;
  };

  # The Linux binary expects a normal distro's loader and libstdc++.
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  # npm/npx/corepack start with `#!/usr/bin/env node`, which works as is.
  dontPatchShebangs = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/etc
    cp -r bin include lib share $out/
    # The store is read-only, so `npm install -g` with this Node goes to
    # ~/.npm-global. Set here, not in NPM_CONFIG_PREFIX or ~/.npmrc, because
    # nvm refuses to run when either of those sets a prefix.
    echo 'prefix=''${HOME}/.npm-global' > $out/etc/npmrc
    runHook postInstall
  '';

  meta = {
    description = "Node.js 24 (official binaries)";
    homepage = "https://nodejs.org";
    license = lib.licenses.mit;
    mainProgram = "node";
    platforms = builtins.attrNames assets;
  };
}
