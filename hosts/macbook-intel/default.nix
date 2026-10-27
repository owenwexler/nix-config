# The Intel Mac (2019 MacBook Pro, macOS Tahoe). Same modules as the M4,
# built from the 26.05 branches (see flake.nix).
{ ... }:
{
  # nixpkgs 26.05 warns on every build that Intel Mac support is ending.
  # Known and accepted; this silences it.
  nixpkgs.config.allowDeprecatedx86_64Darwin = true;
}
