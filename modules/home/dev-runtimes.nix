# Tools that manage themselves outside Nix (NVM, npm globals, rustup's
# toolchain, Grok Build). Each is installed once, on the first switch, and
# skipped after that. A failed download prints a warning instead of failing
# the whole switch; re-run the switch to retry.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  sw = config.dotfiles.software;
  npmGlobals = [
    "lite-server"
    "http-server"
    "nodemon"
    "license"
    "gitconfig"
  ];
  path = lib.makeBinPath [
    pkgs.git
    pkgs.curl
    pkgs.bash
    pkgs.coreutils
    pkgs.gnutar
    pkgs.gzip
    pkgs.unzip
    pkgs.nodejs_24
    pkgs.rustup
  ];
in
{
  home.activation.devRuntimes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${path}:$PATH"
    warn() { echo "dev-runtimes: $*" >&2; }

    # NVM, then the latest LTS Node through it (nvm install --lts)
    if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
      run git clone --quiet --depth 1 --branch v0.40.3 \
        https://github.com/nvm-sh/nvm.git "$HOME/.nvm" || warn "NVM clone failed"
    fi
    if [ -s "$HOME/.nvm/nvm.sh" ]; then
      (
        export NVM_DIR="$HOME/.nvm"
        . "$NVM_DIR/nvm.sh"
        nvm install --lts && nvm alias default "lts/*"
      ) || warn "nvm install --lts failed"
    fi

    # npm install -g, into ~/.npm-global
    export NPM_CONFIG_PREFIX="$HOME/.npm-global"
    for pkg in ${lib.escapeShellArgs npmGlobals}; do
      if [ ! -e "$NPM_CONFIG_PREFIX/lib/node_modules/$pkg" ]; then
        run npm install -g --silent "$pkg" || warn "npm install -g $pkg failed"
      fi
    done

    # Rust: rustup is from Nix, the stable toolchain is installed on first run
    if ! rustup toolchain list 2>/dev/null | grep -q stable; then
      run rustup default stable || warn "rustup default stable failed"
    fi

    ${lib.optionalString sw.ai ''
      # Grok Build: xAI only ships it through this install script
      if [ ! -x "$HOME/.grok/bin/grok" ]; then
        run bash -c 'curl -fsSL https://x.ai/cli/install.sh | bash' || warn "Grok Build install failed"
      fi
    ''}
  '';
}
