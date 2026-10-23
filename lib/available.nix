# Splits a package list into what the machine can run and what it can't.
# Many apps (Zoom, Slack, Spotify, Steam...) only ship x86_64 Linux builds,
# so on an ARM machine/VM they'd fail the whole build. Instead they're left
# out and listed in a build warning.
lib: platform: packages:
let
  ok = p: lib.meta.availableOn platform p;
  skipped = builtins.filter (p: !ok p) packages;
in
{
  packages = builtins.filter ok packages;
  warnings = lib.optional (skipped != [ ]) ''
    Skipped (no ${platform.system} build in nixpkgs): ${
      lib.concatMapStringsSep ", " lib.getName skipped
    }
  '';
}
