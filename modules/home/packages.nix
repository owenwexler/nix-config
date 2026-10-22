# Command-line software that exists on both macOS and Linux.
# GUI apps live in modules/nixos/software.nix (NixOS) and
# modules/darwin/homebrew.nix (macOS casks).
{
  config,
  lib,
  pkgs,
  flakeInputs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
  sw = config.dotfiles.software;
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.packages =
    with pkgs;
    [
      # ---- Misc ----
      curl
      wget
      fastfetch
      sc-im
      inetutils # telnet
      tldr
      fd
      ripgrep
      jq
      unzip
      cmatrix
      flakeInputs.cliamp.packages.${system}.default

      # ---- Dev ----
      gnumake
      vim
      postgresql_17 # psql (the server is a system service)
      sqlite
      redis # redis-cli (the server is a system service)
      (callPackage ../../pkgs/bun-1_4.nix { })
      deno
      turso-cli
      nodejs_22
      (callPackage ../../pkgs/go-1_27.nix { })
      rustup
      dotnetCorePackages.sdk_10_0
      (python3.withPackages (ps: [
        ps.pip
        ps.virtualenv
      ])) # python3 + pip; venv is built in
      pipx
      lazysql
      posting
      tailwindcss_4 # standalone binary, not the npm package
      templ

      # ---- Remote dev ----
      mosh
      autossh
      rsync
      rclone
      mtr
      iperf3
      ncdu
      magic-wormhole
      docker-compose

      # ---- Mobile ----
      android-tools # adb / fastboot
      scrcpy

      # ---- Video / media CLI ----
      ffmpeg
      yt-dlp
      imagemagick
    ]
    ++ lib.optionals sw.kotlinDev [
      jdk21
      gradle
      kotlin
      kotlin-language-server
    ]
    ++ lib.optionals sw.ai [
      claude-code
      codex
      opencode
    ]
    ++ lib.optionals isLinux [
      gcc # LazyVim's treesitter compiles parsers (macOS uses Xcode's clang)
      sshfs
      nvtopPackages.full
      ollama # client; the server is services.ollama
    ]
    ++ lib.optionals isDarwin [
      nvtopPackages.apple
    ];
}
