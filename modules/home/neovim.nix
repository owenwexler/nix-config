# Neovim with the LazyVim starter config and the overrides in nix/nvim/.
# Plugins are managed by lazy.nvim as usual; lazy-lock.json and lazyvim.json
# stay writable because only individual files are linked.
{ lib, pkgs, ... }:
let
  nvim = ../../nvim;
  link = target: source: { "nvim/${target}".source = "${nvim}/${source}"; };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # Tools LazyVim expects to find on PATH
    extraPackages = with pkgs; [
      ripgrep
      fd
      lazygit
      tree-sitter
      nodejs_22
      unzip
      gnumake
    ];
  };

  xdg.configFile = lib.mkMerge [
    (link "init.lua" "init.lua")
    (link "lua/config/lazy.lua" "lazy.lua")
    (link "lua/config/options.lua" "options.lua")
    (link "lua/config/keymaps.lua" "keymaps.lua")
    (link "lua/config/autocmds.lua" "autocmds.lua")
    (link "lua/config/remote_clipboard.lua" "remote_clipboard.lua")
    (link "lua/plugins/colorscheme.lua" "colorscheme.lua")
    (link "lua/plugins/lsp.lua" "lsp.lua")
    (link "lua/plugins/templ.lua" "templ.lua")
  ];
}
