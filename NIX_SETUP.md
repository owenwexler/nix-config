
# NIX/NIXOS SETUP

# Targets
macOS, using Nix for package management and preferably also settings management, fresh install
NixOS, fresh install

# Desired Hardware Targets
## NixOS
Parallels ARM virtual machine running in macOS Sequoia on a MacBook Pro M4
Bare-metal on an Intel PC laptop, most likely 

## Nix-Darwin 
macOS Golden Gate on a MacBook Pro M4
macOS Tahoe on a 2019 Intel MacBook Pro, if possible

# Experimental Features
Use flakes and Home Manager

# Flake Creation Guidance
* Separate generic helper flakes and main flakes for readability
* Use best judgement to determine if the same flake can cover both macOS and NixOS or if different flakes need to be made for each system
* "Make macOS resemble Hyprland as much as possible" is the goal for macOS setup
* if possible genericize/separate software-install flakes so they can be plugged into a custom standalone NixOS scaffold or into an install of [Nixarchy](https://github.com/olafkfreund/nixarchy) seamlessly.

# Time Zone 
America/New York

# MacOS Settings
(macOS) Show no items on desktop or in stage manager
(macOS) Show no widgets
(macOS) Effectively hide the dock (remove everything, set dock to smallest size and on left of screen, check automatically hide and show the dock, disable animate opening applications, uncheck show suggested and recent apps in dock)
(macOS) Finder settings: disable showing anything on the desktop, set default folder as the Home folder, check open folders in tabs instead of new windows, show as list, disable everything under tags
(macOS) Finder sidebar settings - show only Downloads/Documents/Home/Pictures/Movies/Applications 
(macOS) Finder advanced settings - uncheck show warning before changing an extension, set Search Current Folder to search default 
(macOS) View settings - Show Pathbar, Show Status Bar

# Removing The Worst Of Liquid Glass
This may also be settings changes that can't be scripted, please add to the section on unscriptable settings changes in README.md if so.  
(macOS) Accessibility -> Reduce Transparency 
(macOS) System Settings -> Appearance -> Liquid Glass -> Tinted 
(macOS) System Settings -> Appearance -> Liquid Glass -> Tint window background with wallpaper color -> off 

# Karabiner Elements+Hyper Key (macOS Tahoe and later only)
macOS Tahoe and later hijacks many of my most used shortcuts (Option-E, Option-Enter just to name two examples) at the OS level.  This is the workaround that preserves my muscle memory across both macOS and Linux.
(macOS) Karabiner Elements 
(macOS) Setup a Hyper (Shift+Command+Control+Option) key in Karabiner Elements.  Move the Hyper key to where the physical Left Option key is to preserve muscle memory across systems.  Move the Option key to the Caps Lock key. 

# The Mod Key
$mod will hereinafter be the shorthand for the OS-specific mod key used in shortcuts.
(macOS) $mod = Hyper 
(NixOS) $mod = Super

# Window Manager 
(macOS) Aerospace
(macOS) JankyBorders
(NixOS) Hyprland

# Application Launcher
Application launcher hotkey: $mod-D

(macOS) Raycast 
(macOS) Raycast settings: disable window management (Aerospace handles window management), disable clipboard history, disable command-space as keyboard for Spotlight in Keyboard Settings 

(NixOS) Rofi

# Top Bar
(macOS) Sketchybar
(macOS) Setting: auto-hide regular macOS top bar
(macOS) Stats

(NixOS) Waybar

# Terminal 
(macOS) Main terminal: Ghostty, Alternate terminal: Kitty
(NixOS) Main terminal: Foot, Alternate terminal: Kitty

# Browser
Chromium 

# File Explorer 
macOS - Finder 
NixOS - Nautilus

# Shell
Zsh
Oh My Zsh 
bring in aliases from aliases.txt in dotfiles

# Configs 
Bring in configs for all of the above from dotfiles or set up a sensible Omarchy-like config if no config exists in dotfiles

# Other Software
Install all cross-platform software on both macOS and NixOS versions.  Install the equivalent of any software that doesn't exist in both the macOS and NixOS versions.

## Misc
cURL
Fastfetch
NordVPN
1Password
BTOP
Cliamp
Zoom 
Slack 
Spotify 
Dropbox
Eza (ls replacement)
TablePlus 
sc-im
wget 
telnet 
tldr
fzf
zoxide (aliased to cd)
fd 
bat (cat replacement with syntax highlighting)
try
cmatrix

## Dev
Git (setup name and e-mail too)
Make
Vim
Neovim with LazyVim default config and Tokyo Night OLED colors (Tokyo Night with true black background)
POSTGRES/psql
Sqlite3/libsqlite3-dev
REDIS/redis-cli
Bun (1.4)
Deno
Turso
Node/NVM (latest LTS via `nvm install --lts`)
Go (1.27.3, from go.dev)
Rust
Helix 
Zed
VSCode
Helix
.NET
Python3
PIP
Python3-venv
PIPX
lazysql
Posting (also needs PIPX to install)
Tailwind CLI (standalone binary, not the npm -g version)
Templ (templ generate)

## AI 
Claude Code 
Codex 
OpenCode 
Grok Build 
Ollama 

## NPM Global Installs (npm install -g)
lite-server 
http-server 
nodemon 
license 
gitconfig 

## Gaming
Steam 
RetroArch - DOS abandonware/DOSBox, PlayStation, SNES, NES, Mega Drive/Master System/Game Gear, Game Boy/Game Boy Color/Game Boy Advance, DS, 3DS, N64, Dreamcast, PSP, MAME/arcade

## Remote Dev
Mosh 
Tailscale
tmux 
autossh 
sshfs 
rsync 
rclone 
git-lfs 
lazygit 
GitHub CLI 
Docker + docker-compose 
mtr 
iperf3 
ncdu 
nvtop 
magic-wormhole

## Remote GUI
(NixOS) Waypipe (macOS) macOS equivalent 
(NixOS) xorg-xauth 
FreeRDP + Remmina + TigerVNC (full remote desktop; RDP beats VNC for video)
(NixOS) wayvnc (HOST side: VNC server for a headless wlroots session)
Moonlight (CLIENT side: GPU-encoded low-latency streaming. This is the one
  that makes remote Godot and remote video scrubbing actually usable.)
Sunshine (HOST side pair to Moonlight)

## Mobile Dev 
(macOS) XCode / XCode CLI tools
(macOS) iPhone Simulators
Android Studio 
Android Simulators
android-tools (adb/fastboot - adb connects over Tailscale, no USB needed)
scrcpy (mirror and control a physical Android device over adb; works against
  a remote emulator too)
OpenJDK (Gradle/Android toolchain)
(NixOS) libimobiledevice (basic iOS device chat from Linux)

## Kotlin Dev
jdk21-openjdk
Gradle
Kotlin compiler CLI
IntelliJ IDEA Community Edition 
kotlin-language-server (for nvim/Helix/Zed - GitHub release zip, JVM app)
  it's arch-independent and works on both machines)

## Game Dev
GODOT
Tiled (tilemap/level editor)
Krita 
GIMP
Audacity + LMMS (SFX and music)
Blender 

## Video Editing
(NixOS) Kdenlive (full NLE, in the repos)
(NixOS) Shotcut (lighter second opinion)
DaVinci Resolve
Adobe Creative Cloud
ffmpeg (the actual workhorse - proxy generation, remote render, transcode)
HandBrake
mpv (review)
yt-dlp
ImageMagick

## Virtual Machines
Parallels
UTM 
(macOS) Try Omarchy 

# Theme 
[Tokyo Night OLED](https://github.com/Justin-De-Sio/omarchy-tokyoled-theme) (Tokyo Night colors with #fff white text and #000 true black background)
(macos) Earth/space pictures rotation that comes with macOS with Tokyo Night OLED colors color themes for Neovim, Eza, Btop, Ghostty, Kitty, FastFetch, LazySQL, Posting, Nautilus
(NixOS) adapt the [Tokyo Night OLED Omarchy theme](https://github.com/Justin-De-Sio/omarchy-tokyoled-theme) for NixOS/Hyprland, replace 

# Font
JetBrains Mono Nerd Font

# Keyboard Shortcuts
$mod-D - Raycast/Rofi
$mod-Enter - Terminal 
$mod-B - Chromium 
$mod-E - Finder/Nautilus 
$mod-P - Parallels
(macOS) $mod-O - Try Omarchy
