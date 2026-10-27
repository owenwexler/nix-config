# SketchyBar (stand-in for the Waybar top bar). Item and plugin scripts are
# in nix/sketchybar (copied from macos-2024-m4/sketchybar); the colors and the
# bar itself are Tokyo Night OLED versions defined here.
{ ... }:
let
  c = import ../../palette.nix;
  src = ../../../sketchybar;
  argb = hex: "0xff${hex}";
in
{
  xdg.configFile = {
    "sketchybar/items".source = "${src}/items";
    "sketchybar/plugins".source = "${src}/plugins";

    "sketchybar/variables.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env sh
        # Tokyo Night OLED
        BLACK=${argb c.background}
        WHITE=${argb c.foreground}
        MAGENTA=${argb c.magenta}
        BLUE=${argb c.blue}
        CYAN=${argb c.cyan}
        GREEN=${argb c.green}
        YELLOW=${argb c.yellow}
        ORANGE=${argb c.orange}
        RED=${argb c.red}
        BAR_COLOR=${argb c.background}
        COMMENT=${argb c.comment}
        TRANSPARENT=0x00000000

        ICON_COLOR=$WHITE
        LABEL_COLOR=$WHITE

        ITEM_DIR="$HOME/.config/sketchybar/items"
        PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

        FONT="JetBrainsMono Nerd Font"
        PADDINGS=3

        POPUP_BORDER_WIDTH=2
        POPUP_CORNER_RADIUS=11
        POPUP_BACKGROUND_COLOR=$BLACK
        POPUP_BORDER_COLOR=$BLUE

        CORNER_RADIUS=15
        BORDER_WIDTH=2
        SHADOW=on
      '';
    };

    "sketchybar/sketchybarrc" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:$PATH" # Apple Silicon, Intel

        source "$HOME/.config/sketchybar/variables.sh"

        sketchybar --bar height=30 \
          color="$BAR_COLOR" \
          shadow="$SHADOW" \
          position=top \
          drawing=on \
          display=main \
          sticky=on \
          padding_right=0 \
          padding_left=2 \
          corner_radius="$CORNER_RADIUS" \
          y_offset=2 \
          margin=2 \
          blur_radius=20 \
          notch_width=200 \
          --default updates=when_shown \
          icon.font="$FONT:Bold:13.5" \
          icon.color="$ICON_COLOR" \
          icon.padding_left="$PADDINGS" \
          icon.padding_right="$PADDINGS" \
          label.font="$FONT:Bold:13.0" \
          label.color="$LABEL_COLOR" \
          label.padding_left="$PADDINGS" \
          label.padding_right="$PADDINGS" \
          background.padding_right="$PADDINGS" \
          background.padding_left="$PADDINGS" \
          popup.background.border_width=1 \
          popup.background.corner_radius=11 \
          popup.background.border_color="$POPUP_BORDER_COLOR" \
          popup.background.color="$POPUP_BACKGROUND_COLOR" \
          popup.background.shadow.drawing="$SHADOW"

        # Aerospace workspaces; the focused one gets a Tokyo Night blue outline.
        sketchybar --add event aerospace_workspace_change
        for sid in $(aerospace list-workspaces --all); do
          sketchybar --add item space.$sid left \
            --subscribe space.$sid aerospace_workspace_change \
            --set space.$sid \
            background.color=$TRANSPARENT \
            background.border_color=$BLUE \
            background.border_width=2 \
            background.corner_radius=5 \
            background.height=20 \
            background.drawing=off \
            icon.drawing=off \
            label="$sid" \
            label.padding_left=8 \
            label.padding_right=8 \
            click_script="aerospace workspace $sid" \
            script="$PLUGIN_DIR/aerospace.sh $sid"
        done

        source "$ITEM_DIR/front_app.sh"

        source "$ITEM_DIR/clock.sh"
        source "$ITEM_DIR/calendar.sh"
        source "$ITEM_DIR/battery.sh"
        source "$ITEM_DIR/volume.sh"
        source "$ITEM_DIR/cpu.sh"

        sketchybar --hotload true
        sketchybar --update
      '';
    };
  };
}
