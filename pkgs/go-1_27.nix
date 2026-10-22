# Go pinned to 1.27.x, from go.dev's binary tarball rather than nixpkgs' `go`,
# so the version is set here.
# To bump: change `version`, then refresh the four hashes from go.dev's
#   https://go.dev/dl/?mode=json&include=all (the "sha256" of each archive file)
{
  stdenv,
  fetchurl,
}:
let
  version = "1.27.3";
  assets = {
    x86_64-linux = {
      name = "linux-amd64";
      hash = "sha256-Ze+8gP3B+izSYxytW0gXd6aOhyXzTon1D8ascU43m0A=";
    };
    aarch64-linux = {
      name = "linux-arm64";
      hash = "sha256-oG6ZMJ28vcoajM0igsPuFG5VkwiG4mtPEZMmlYcWX0k=";
    };
    aarch64-darwin = {
      name = "darwin-arm64";
      hash = "sha256-3TkIzyCVnXmMHgbr5bciE/BQXOATc7QM4xEJdabNmcI=";
    };
    x86_64-darwin = {
      name = "darwin-amd64";
      hash = "sha256-tvjpMeSrSX/N5tqK5EmaWPnSWOVcioCCSlFurllQp1A=";
    };
  };
  asset =
    assets.${stdenv.hostPlatform.system}
      or (throw "go 1.27: no binary for ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "go";
  inherit version;
  src = fetchurl {
    url = "https://go.dev/dl/go${version}.${asset.name}.tar.gz";
    inherit (asset) hash;
  };
  # The tarball unpacks to one `go/` directory, which stdenv steps into for us.
  dontBuild = true;
  dontConfigure = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r . $out/
    runHook postInstall
  '';
}
