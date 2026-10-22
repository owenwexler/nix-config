-- ~/.config/hypr/bindings.lua
-- -----------------------------------------------------
-- i3 / Sway / Aerospace muscle memory for Omarchy 4
-- -----------------------------------------------------
-- Installed by ~/dotfiles/omarchy/install.sh. This is the successor to the old
-- hypr/userprefs.conf: Omarchy 4 ("quattro") moved Hyprland from hyprlang to
-- Hyprland's Lua config, and ~/.config/hypr/hyprland.lua loads this file with
-- `require("hypr.bindings")` AFTER Omarchy's own defaults, so everything here
-- wins without any of the source-ordering games the .conf version needed.
--
-- One placeholder is filled in at install time:
--   @LAUNCHER@  -- the app launcher command Omarchy actually uses on this box
--
-- To see the live list of every binding, defaults included:
--   omarchy-menu-keybindings     (SUPER + SHIFT + ALT + K, rehomed below)
--
-- =====================================================================
-- HOW THIS DIFFERS FROM THE OLD userprefs.conf, AND WHY
-- =====================================================================
--
-- 1. The main modifier is still SUPER, and on Mac hardware hypr/input.lua
--    swaps Alt and Super at the KEYBOARD LAYOUT level, so SUPER is physically
--    the Option key. Same spot on the keyboard as the Windows key on a PC.
--    That swap is in input.lua, not here -- it has to be an input setting,
--    because it also has to apply to the bar, the terminal and every app, not
--    just to Hyprland's binds.
--
-- 2. There is no generated unbind file any more. The .conf version had to
--    scan Omarchy's config and emit `unbind` lines because hyprlang expands
--    variables at parse time. Lua has none of that problem: the unbinds are
--    written out below, by hand, next to the bind that replaces them, with a
--    comment saying what was there before.
--
-- 3. Workspace switching is NOT redefined here. Omarchy already binds
--    SUPER + 1..0 to workspaces 1..10 and SUPER + SHIFT + 1..0 to move-window,
--    by keycode, which is exactly the i3 behaviour. Rebinding them would put
--    two binds on one key and make workspace_back_and_forth toggle twice.
--    The back-and-forth behaviour itself is turned on at the bottom of
--    this file instead.
--
-- 4. SUPER + Return is NOT rebound. In Omarchy 4 it runs omarchy-launch-terminal,
--    which goes through xdg-terminal-exec -- and install.sh puts foot.desktop at
--    the top of ~/.config/xdg-terminals.list. So Return already opens foot, and
--    it keeps the two things a hard-coded bind would throw away: the new window
--    inherits the current terminal's directory, and SUPER + ALT + Return still
--    opens foot with tmux attached.

-- Unbinding a key that was never bound should be harmless, but a future
-- Omarchy could rename or drop any of these defaults. pcall keeps one stale
-- unbind from aborting the whole file and leaving you with half a keymap.
local function unbind(keys)
	pcall(hl.unbind, keys)
end

-- ---------------------------------------------------------------------------
-- 1. App launcher (i3's $mod+d) and browser (i3's $mod+b)
-- ---------------------------------------------------------------------------
-- Omarchy 4 has no rofi and no standalone walker binding: SUPER + SPACE opens
-- the Omarchy menu and SUPER + ALT + SPACE opens its apps pane. install.sh
-- resolves the real command on this machine and substitutes it here, so both
-- the Omarchy defaults and Option+D keep working.
unbind("SUPER + D")
o.bind("SUPER + D", "App launcher", "@LAUNCHER@")

-- i3's $mod+b. Omarchy 4 puts the browser on SUPER + SHIFT + B and
-- SUPER + SHIFT + RETURN, so plain SUPER + B is free and both defaults survive.
--
-- `{ omarchy = "browser" }` is Omarchy's own way of spelling this: o.bind turns
-- a table with an `omarchy` key into "omarchy-launch-" .. value, so this runs
-- omarchy-launch-browser -- the same thing the two defaults above run. That
-- script resolves the browser through `xdg-settings get default-web-browser`,
-- so it follows whatever you set as the system default and keeps working if you
-- ever switch off Chromium. There is no $BROWSER variable in the Lua config
-- (hyprlang's `$browser` is gone with it), and hardcoding "chromium" here would
-- make this the one browser key that ignores your default.
unbind("SUPER + B")
o.bind("SUPER + B", "Browser", { omarchy = "browser" })

-- ---------------------------------------------------------------------------
-- 2. i3-style window focus directionals (HJKL)
-- ---------------------------------------------------------------------------
-- Three of these four keys are live Omarchy defaults, so they go first.
unbind("SUPER + H")
unbind("SUPER + J") -- was: Toggle window split
unbind("SUPER + K") -- was: Keybindings menu
unbind("SUPER + L") -- was: Toggle workspace layout

o.bind("SUPER + H", "Focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus right", hl.dsp.focus({ direction = "r" }))

-- New homes for the three defaults HJKL displaced. Delete these three lines if
-- you never use them; the arrow-key equivalents are all still Omarchy's.
-- (SUPER + CTRL + K is the Herdr keybindings menu and SUPER + ALT + K becomes
-- resize in section 6, so the main menu lands on the four-finger version.)
o.bind("SUPER + CTRL + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + SHIFT + ALT + K", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + SHIFT + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- ---------------------------------------------------------------------------
-- 3. i3-style window shifting (mod + Shift + HJKL)
-- ---------------------------------------------------------------------------
-- Hyprland's "move" in a tiled layout is a swap with the neighbour, which is
-- what i3 does too. Omarchy binds the same action to SUPER + SHIFT + arrows.
unbind("SUPER + SHIFT + H")
unbind("SUPER + SHIFT + J")
unbind("SUPER + SHIFT + K")
unbind("SUPER + SHIFT + L")

o.bind("SUPER + SHIFT + H", "Move window left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Move window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Move window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Move window right", hl.dsp.window.swap({ direction = "r" }))

-- ---------------------------------------------------------------------------
-- 4. Back-and-forth workspace toggle (i3's $mod+Tab)
-- ---------------------------------------------------------------------------
unbind("SUPER + TAB") -- was: next workspace, rehomed just below
unbind("SUPER + CTRL + TAB") -- was: former workspace, which is what Tab does now

o.bind("SUPER + TAB", "Former workspace", hl.dsp.focus({ workspace = "previous" }))
o.bind("SUPER + CTRL + TAB", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
-- SUPER + SHIFT + TAB is still Omarchy's "previous workspace" (e-1).

-- ---------------------------------------------------------------------------
-- 5. Close, float, reload (the rest of the i3 defaults you reach for)
-- ---------------------------------------------------------------------------
-- i3's $mod+Shift+q. Omarchy's SUPER + W and SUPER + Q still close too.
unbind("SUPER + SHIFT + Q")
o.bind("SUPER + SHIFT + Q", "Close window", hl.dsp.window.close())

-- i3's $mod+Shift+space. This one takes a key Omarchy uses for the top bar,
-- so the bar toggle is rehomed rather than lost. SUPER + T also floats.
unbind("SUPER + SHIFT + SPACE") -- was: toggle top bar
o.bind("SUPER + SHIFT + SPACE", "Toggle window floating", hl.dsp.window.float({ action = "toggle" }))
o.bind_toggle("SUPER + CTRL + B", "Toggle top bar", "bar")

-- i3's $mod+Shift+c -- reload the config in place.
-- This displaces Omarchy's Calendar web app. It is still one keystroke away in
-- the apps menu, so it is not rehomed here.
unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Reload Hyprland config", "hyprctl reload")

-- i3's $mod+f is already Omarchy's "Full screen", so it is left alone.

-- ---------------------------------------------------------------------------
-- 6. Resize on held modifiers (mod + Alt + HJKL)
-- ---------------------------------------------------------------------------
-- This was an i3-style `mod+r` resize submap. It is not, any more, and the
-- reason is worth writing down so nobody puts it back:
--
--   hl.define_submap("resize", ...) worked and the resize keys inside it worked,
--   but hl.dsp.submap("default") -- the documented way back out -- throws
--   "cannot set submap default (doesn't exist!)" on every press. Hyprland's
--   nameless root submap is not addressable by name from Lua, so there was no
--   exit from the mode, and every Escape stacked up another error window.
--
-- Held modifiers do the same job with no mode to be trapped in. HJKL keeps the
-- i3 sense: H/L narrow and widen, J/K grow and shrink height.
--
-- SUPER + ALT + H, J and L are unused in Omarchy 4. SUPER + ALT + K is its tmux
-- keybindings menu, so that one is rehomed rather than lost. Omarchy's own
-- resize keys (SUPER + bracket, with ALT for small steps and CTRL for large)
-- are untouched, so this is an addition, not a replacement.
unbind("SUPER + ALT + K") -- was: tmux keybindings menu, rehomed on the next line
o.bind("SUPER + CTRL + ALT + K", "Tmux keybindings", "omarchy-menu-tmux-keybindings")

unbind("SUPER + ALT + H")
unbind("SUPER + ALT + J")
unbind("SUPER + ALT + L")

-- 40px a press, and `repeating` means holding the combo keeps resizing, which is
-- what made the submap feel good in the first place.
o.bind(
	"SUPER + ALT + H",
	"Shrink window width",
	hl.dsp.window.resize({ x = -40, y = 0, relative = true }),
	{ repeating = true }
)
o.bind(
	"SUPER + ALT + J",
	"Grow window height",
	hl.dsp.window.resize({ x = 0, y = 40, relative = true }),
	{ repeating = true }
)
o.bind(
	"SUPER + ALT + K",
	"Shrink window height",
	hl.dsp.window.resize({ x = 0, y = -40, relative = true }),
	{ repeating = true }
)
o.bind(
	"SUPER + ALT + L",
	"Grow window width",
	hl.dsp.window.resize({ x = 40, y = 0, relative = true }),
	{ repeating = true }
)

-- ---------------------------------------------------------------------------
-- 7. i3-style back-and-forth engine
-- ---------------------------------------------------------------------------
hl.config({
	binds = {
		-- Pressing the active workspace's key again bounces to the previous one.
		workspace_back_and_forth = true,

		-- Keeps the workspace history stack, so `previous` above works.
		allow_workspace_cycles = true,
	},
})

-- ---------------------------------------------------------------------------
-- 8. Terminal for anything Hyprland shells out to
-- ---------------------------------------------------------------------------
-- Keybind dispatchers do not see `hyprctl setenv`, so this has to be hl.env.
-- ~/.config/uwsm/env sets the same variable for regular apps.
hl.env("TERMINAL", "foot")
