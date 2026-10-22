# Karabiner-Elements (macOS Tahoe+ grabs shortcuts like Option-E and
# Option-Enter at the OS level; this keeps the Linux muscle memory).
#
#   Left Option  -> Hyper (Shift+Cmd+Ctrl+Opt), the macOS $mod
#   Caps Lock    -> Option (right Option, so it isn't turned into Hyper too)
#   Hyper + physical Shift + key -> Cmd+Ctrl+Opt+key, so Aerospace can tell
#                   "$mod+Shift+key" apart from "$mod+key"
#
# Karabiner rewrites karabiner.json when you touch its settings, so the file
# is copied (not linked). Each switch replaces it with this version.
{
  lib,
  pkgs,
  ...
}:
let
  hyperModifiers = [
    "left_command"
    "left_control"
    "left_option"
  ];

  # Keys used with $mod+Shift in Aerospace (modules/darwin/services.nix).
  shiftLayerKeys = [
    "h"
    "j"
    "k"
    "l"
    "q"
    "spacebar"
    "semicolon"
    "return_or_enter"
  ]
  ++ map toString (lib.range 0 9);

  trackShift = key: {
    type = "basic";
    from = {
      key_code = key;
      modifiers.optional = [ "any" ];
    };
    to = [
      {
        set_variable = {
          name = "physical_shift";
          value = 1;
        };
      }
      { key_code = key; }
    ];
    to_after_key_up = [
      {
        set_variable = {
          name = "physical_shift";
          value = 0;
        };
      }
    ];
  };

  hyperShiftKey = key: {
    type = "basic";
    conditions = [
      {
        type = "variable_if";
        name = "hyper";
        value = 1;
      }
      {
        type = "variable_if";
        name = "physical_shift";
        value = 1;
      }
    ];
    from = {
      key_code = key;
      modifiers.mandatory = [
        "command"
        "control"
        "option"
        "shift"
      ];
    };
    to = [
      {
        key_code = key;
        modifiers = hyperModifiers;
      }
    ];
  };

  config = {
    global.show_in_menu_bar = false;
    profiles = [
      {
        name = "Default";
        selected = true;
        virtual_hid_keyboard.keyboard_type_v2 = "ansi";
        simple_modifications = [
          {
            from.key_code = "caps_lock";
            to = [ { key_code = "right_option"; } ];
          }
        ];
        complex_modifications.rules = [
          {
            description = "Track physical Shift (for Hyper+Shift shortcuts)";
            manipulators = map trackShift [
              "left_shift"
              "right_shift"
            ];
          }
          {
            description = "Hyper + Shift + key -> Cmd+Ctrl+Opt + key";
            manipulators = map hyperShiftKey shiftLayerKeys;
          }
          {
            description = "Left Option -> Hyper (Shift+Cmd+Ctrl+Opt)";
            manipulators = [
              {
                type = "basic";
                from = {
                  key_code = "left_option";
                  modifiers.optional = [ "any" ];
                };
                to = [
                  {
                    set_variable = {
                      name = "hyper";
                      value = 1;
                    };
                  }
                  {
                    key_code = "left_shift";
                    modifiers = hyperModifiers;
                  }
                ];
                to_after_key_up = [
                  {
                    set_variable = {
                      name = "hyper";
                      value = 0;
                    };
                  }
                ];
              }
            ];
          }
        ];
      }
    ];
  };

  configFile = (pkgs.formats.json { }).generate "karabiner.json" config;
in
{
  home.activation.karabiner = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    dest="$HOME/.config/karabiner/karabiner.json"
    if ! cmp -s "${configFile}" "$dest"; then
      run mkdir -p "$(dirname "$dest")"
      run install -m 0644 "${configFile}" "$dest"
    fi
  '';
}
