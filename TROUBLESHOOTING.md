A concise summary of troubleshooting steps and technical solutions learned from the first NixOS run

For the next run I am going to delete the current VM, create a new one, and install from scratch.

1. nixos-rebuild Unrecognized Arguments Error

• The Symptom: Passing core Nix configurations like --option experimental-features "nix-command flakes" directly to nixos-rebuild switch resulted in an unrecognized arguments syntax block.
• The Cause: nixos-rebuild is a helper script wrapper that does not directly parse core nix evaluation flags.
• The Solution: Pass temporary configurations to the underlying evaluator inline via the NIX_CONFIG environment variable prefix:bash
sudo NIX_CONFIG="experimental-features = nix-command flakes" nixos-rebuild switch --flake /nix-config#nixos
Use code with caution.
• Permanent Fix: Declare the experimental features directly within the system configuration module tree so flags are unnecessary going forward:nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];

2. Architecture Assertion Errors (hardware.graphics.enable32Bit)

• The Symptom: Evaluation aborted with a message stating that hardware.graphics.enable32Bit is only supported on x86_64 configurations.
• The Cause: The parameter (or its legacy alias hardware.opengl.driSupport32Bit) was being turned on implicitly by inherited configuration layers or imported hardware modules, breaking build execution inside non-x86 spaces like virtual machine targets.
• The Solution: Explicitly intercept and invalidate the evaluation block by forcefully passing a override statement inside your primary host layout profile (e.g., configuration.nix) rather than the core structural flake.nix layout:nix
{ config, pkgs, lib, ... }: {
  hardware.graphics.enable32Bit = lib.mkForce false;
}
ADDENDUM: Maybe conditionally activate this only on ARM?

3. Upstream Binary Cache Network Drops and Timeouts

• The Symptom: Large systemic environment updates (~23GB footprints) abruptly crashed mid-stream with Timeout was reached (28) or SSL connect error (35) Recv failure.
• The Cause: Concurrent data requests saturated internal virtual machine NAT channels and tripped protective rate-limiting mechanisms on the upstream edge servers hosting cache.nixos.org.
• The Solution: Stagger and throttle network deployment routines down to sequential single-threaded downloads with highly persistent connection attempts:bash
sudo nixos-rebuild switch --flake /nix-config#nixos \
  --max-jobs 1 \
  --option workers 1 \
  --option download-attempts 10

RELATED PROBLEM: Installs fail when the computer goes to sleep.
SOLUTION: Keep the computer awake with Amphetamine or macOS settings during NixOS builds.

4. Cryptographic Hash Mismatch Errors

• The Symptom: Fixed-output source package derivations (like Go modules or dependencies for applications like cliamp) aborted evaluation with an asset integrity mismatch error (specified hash: sha256-X..., got hash: sha256-Y...).
• The Cause: Upstream sources altered files or dependencies under a targeted commit without updating the downstream package script specification.
• The Solution: Use grep -rn "package-name" /nix-config/ to track down the module definition, swap the string listed under sha256 or vendorHash with the new target hash reported by Nix, stage the modifications to the git layout (git add .), and re-run your build sequence.
• Alternate Solution (not preferred): Omit cliamp from install 

5. System Lockout and Missing Command Path in Recoveries

• The Symptom: Streamlining configuration files accidentally dropped your local user permissions block or password generation states from the active profile setup, resulting in a login lockout. Standard recovery calls like mount returned command not found while using recovery hooks.
• The Cause: NixOS structures system binaries cleanly within specific store profile references; they do not natively load into an initial bare system path loop during absolute low-level emergency intercepts (init=/bin/sh).
• The Solution: Invoke core utility actions by parsing their exact system directory targets directly from the prompt:sh
/run/current-system/sw/bin/mount -o remount,rw /
/run/current-system/sw/bin/passwd owen
/run/current-system/sw/bin/reboot -f
• The Permanent Solution: A mechanism for preserving the user password in the Nix config without revealing it in plain text in the repo.

Best-Practice Password Preservation Checklist for Your Next Rebuild:

• Never write raw password text strings in .nix configuration layers.
• Generate a static SHA-512 text representation via the terminal command: mkpasswd -m sha-512
• Place the output string inside your machine's profile configuration block under users.users.owen.hashedPassword = "$6$..."; or reference a local out-of-repo path with hashedPasswordFile = "/etc/user-password.txt"; so updates can never drop your user profiles again.
(I would like to go with the out-of-repo user-password.txt and have that be .gitignored with instructions for how to generate in the default NixOS XFCE shell added to the README)

6.  Steam does not have an ARM package and this is stopping builds 
• The Symptom: Attempting to install Steam crashes the entire build
• The Cause: Missing ARM package for Steam, most likely
• The Solution: Add Steam to the list of skipped applications on ARM

7.  Theme issues with Neovim and Catpuccin Mocha Dark 
• The Symptom: Catpuccin Mocha Neovim theme stubbornly retains purple background despite specifying the Mocha theme and several manual #000 overrides in colorscheme.lua
• The Cause: Missing ARM package for Steam, most likely
• The Solution: See below

I would like to switch the theme for both my NixOS config and the color scheme for my macOS nix-darwin config to **Tokyo Night OLED** (also known as **Tokyoled**).  Instead of a black background in NixOS (as supplied by the theme) please use 3-4 high-res (2K or above) free-use pictures of Earth from outer space, acting in parallel with (but not an exact mirror of) the macOS background aesthetic.  Thank you!
The repo for this theme can be found here: https://github.com/Justin-De-Sio/omarchy-tokyoled-theme

8.  nixpkgs-unstable on Intel Macs 
I've been told nixpkgs-unstable is incompatible with Intel Macs.  Is there any way to make the nix-darwin configuration work on both an M4 Mac running Golden Gate (as my M4 will be once Sequoia goes end-of-life and I rebuild my system from scratch using Nix on Golden Gate) and an Intel Mac running Tahoe (I want to rebuild my Intel Mac's Tahoe system on Nix at this time if possible)?

Thank you!

Claude Opus 5.5 Response:
I've applied every fix from TROUBLESHOOTING.md, switched both configs to Tokyo Night OLED, and added a separate config for the Intel Mac. None of it has been test-built, because Nix isn't installed on this machine. Before your next VM install, do three things:

- Track the new files: run git add nix/hosts/macbook-intel (Nix ignores files git doesn't track).
- Expect a flake.lock change: it doesn't list the three new Intel Mac inputs yet. The first build adds them, so commit flake.lock afterwards.
- Match the usernames: your notes show passwd owen, but settings.nix uses owenwexler. The installer's user is deleted on the first switch, which is probably what locked you out. Either create owenwexler in the installer or change username in settings.nix.

Install fixes

1. Flakes command: the README now uses your NIX_CONFIG command. Flakes stay on permanently after the first switch, as before.
2. 32-bit graphics error: 32-bit graphics are now forced off on ARM, as you suggested.
3. Network drops:
   - The first-install command in the README downloads one thing at a time and retries up to 10 times.
   - Every later rebuild also retries up to 10 times.
   - The README tells you to keep the Mac awake (Amphetamine or caffeinate).
4. Hash mismatch: cliamp's own flake pins the wrong hash for its Go dependencies. I worked out the correct one, after checking my method against a hash Nix had already recorded, and override it in our config. cliamp stays installed. Bun and Go hashes still match their official downloads.
5. Password: your hashed password lives in /etc/nixos/user-password.txt, outside the repo, and user-password.txt is also in .gitignore. The README has the mkpasswd steps for the XFCE terminal. If the file is missing, the switch now refuses to run instead of creating a user with no password.
6. Steam: this was also the cause of the 32-bit error. Steam's package claims ARM support, so my previous check let it through. Steam now only turns on on Intel/AMD.

Theme (#7)

- Shared colors: one palette using the colors from the theme repo, with pure white text on true black. It feeds Neovim, btop, eza, fzf, Posting, Kitty, Ghostty, Foot, Waybar, Rofi, Hyprland borders, GTK/Nautilus, SketchyBar and JankyBorders.
- Icons: Yaru-magenta, which the theme repo sets.
- Neovim: now uses tokyonight. It forces every background to black, including floating windows, sidebars and the status line, so the purple background shouldn't come back.
- NixOS wallpapers: four public-domain NASA photos, all 3000 px or larger: Blue Marble, Earthrise, and two shots of Earth's horizon from the ISS. Hyprland picks a random one at login, and Super+Ctrl+Space shows the next.
- macOS wallpaper: stays on Apple's built-in Earth set.

Intel Mac (#8)

Yes, with a time limit. nixpkgs 26.05 is the last release that supports Intel Macs, and it gets updates until the end of 2026 (NixOS 26.05 announcement (https://nixos.org/blog/announcements/2026/nixos-2605/), Discourse thread (https://discourse.nixos.org/t/x86-64-darwin-removal-and-wine/77532)).

- New config: #macbook-intel uses the 26.05 versions of nixpkgs, nix-darwin and Home Manager. The M4 stays on the latest packages (#macbook).
- After 2026: it keeps working, but the Nix packages stop getting updates. Homebrew apps update as usual.
- Skipped on Intel: cliamp and Try Omarchy, which have no Intel build.

I also changed the "Stickybar" row in the README to SketchyBar to match your spec edit. The README now has a Troubleshooting section with the hash-fix steps and the recovery commands. Nothing is committed.

Sources:
- Nixpkgs release notes (https://nixos.org/manual/nixpkgs/stable/release-notes.html)
- MyNixOS: system.preSwitchChecks (https://mynixos.com/nixpkgs/option/system.preSwitchChecks)
