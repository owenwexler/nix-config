-- ~/.config/hypr/input.lua
-- -----------------------------------------------------
-- Mac keyboard: swap Alt and Super at the layout level
-- -----------------------------------------------------
-- Installed by ~/dotfiles/omarchy/install.sh. Omarchy 4 loads this file from
-- ~/.config/hypr/hyprland.lua (`require("hypr.input")`) AFTER its own defaults,
-- so anything set here wins.
--
-- Only installed when MAC_KEYBOARD=true in install.sh. On PC hardware the
-- script skips it and leaves Omarchy's input.lua alone.
--
-- WHY THIS AND NOT `$mainMod = ALT`:
-- On a Mac keyboard the bottom row reads Control / Option / Command. On a PC
-- keyboard it reads Control / Super(Win) / Alt. So the key sitting in the PC
-- "Super" position on a Mac is Option, and the key in the PC "Alt" position is
-- Command.
--
-- altwin:swap_alt_win swaps the two, which makes the physical Option key emit
-- Super and the physical Command key emit Alt. Result: every SUPER binding
-- fires from Option, exactly like the Windows key does on a PC and exactly like
-- your Aerospace setup -- and it applies system-wide (the bar, the terminal,
-- every app), not just to Hyprland binds.

-- NOTE ON THE OTHER TWO OPTIONS: Omarchy's own default/hypr/input.lua sets
-- kb_options = "compose:caps,shift:both_capslock_cancel". hl.config replaces
-- the whole string rather than appending to it, so both are repeated here --
-- drop them and you silently lose Compose-on-CapsLock and the both-Shift
-- CapsLock cancel.
hl.config({
  input = {
    kb_options = "compose:caps,shift:both_capslock_cancel,altwin:swap_alt_win",
  },
})

-- ---------------------------------------------------------------------------
-- Everything below is Omarchy's stock commented reference, left in place so
-- this file is still a usable starting point for other input tweaks.
-- ---------------------------------------------------------------------------

-- Keyboard layout and options.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
-- hl.config({
--   input = {
--     -- Use multiple keyboard layouts and switch between them with Left Alt + Right Alt.
--     kb_layout = "us,dk,eu",
--
--     -- Use a specific keyboard variant if needed (e.g. intl for international keyboards).
--     kb_variant = "intl",
--
--     -- Change speed of keyboard repeat.
--     repeat_rate = 40,
--     repeat_delay = 250,
--
--     -- Start with numlock on by default.
--     numlock_by_default = true,
--
--     -- Increase sensitivity for mouse/trackpad (default: 0).
--     sensitivity = 0.35,
--
--     -- Turn off mouse acceleration (default: adaptive).
--     accel_profile = "flat",
--
--     touchpad = {
--       -- Use natural (inverse) scrolling.
--       natural_scroll = true,
--
--       -- Use two-finger clicks for right-click instead of lower-right corner.
--       clickfinger_behavior = true,
--
--       -- Control the speed of your scrolling.
--       scroll_factor = 0.4,
--
--       -- Enable the touchpad while typing.
--       disable_while_typing = false,
--
--       -- Left-click-and-drag with three fingers.
--       drag_3fg = 1,
--     },
--   },
-- })

-- App-specific touchpad scroll speeds.
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })

-- Enable touchpad gestures for changing workspaces.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Enable touchpad gestures for moving focus (helpful on scrolling layout).
-- hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
-- hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
