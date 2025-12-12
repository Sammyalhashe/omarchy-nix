inputs: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.omarchy;

  # Helper to translate Hyprland keybind syntax to Mangowc
  # Hyprland: "MOD, KEY, dispatcher, arg"
  # Mangowc: "bind=MOD,KEY,dispatcher,arg" or similar
  # We need to map dispatchers too.
  translateBind = binding: let
    parts = lib.splitString "," binding;
    mod = lib.trim (builtins.elemAt parts 0);
    key = lib.trim (builtins.elemAt parts 1);
    dispatcher = lib.trim (builtins.elemAt parts 2);
    arg =
      if builtins.length parts > 3
      then lib.trim (lib.concatStringsSep "," (lib.drop 3 parts))
      else "";

    # Mapper for modifiers
    mapMod = m:
      lib.replaceStrings
      ["SUPER" "SHIFT" "CTRL" "ALT" "space" "return" "slash" "backslash" "minus" "equal" "comma" "period" "left" "right" "up" "down" "ESCAPE"]
      ["SUPER" "SHIFT" "CTRL" "ALT" "space" "Return" "slash" "backslash" "minus" "equal" "comma" "period" "Left" "Right" "Up" "Down" "Escape"]
      m;

    # Mapper for dispatchers
    mappedDispatcher =
      if dispatcher == "exec"
      then "spawn"
      else dispatcher; # Fallback

    # For exec/spawn, arg is the command.
    # For others, we might need specific mapping logic if we supported full translation.
    # The requirement is mainly for "quick_app_bindings" which are mostly execs.

    finalCmd = if arg != "" then "${mappedDispatcher},${arg}" else "${mappedDispatcher},";

  in "bind=${mapMod mod},${mapMod key},${finalCmd}";

  quickAppBindings = map translateBind cfg.quick_app_bindings;

  # Core bindings ported from Hyprland config
  coreBindings = [
    # Window management
    "bind=SUPER,W,killclient,"
    "bind=SUPER,Backspace,killclient,"

    # Focus
    "bind=SUPER,Left,focusdir,left"
    "bind=SUPER,Right,focusdir,right"
    "bind=SUPER,Up,focusdir,up"
    "bind=SUPER,Down,focusdir,down"
    "bind=SUPER,h,focusdir,left"
    "bind=SUPER,l,focusdir,right"
    "bind=SUPER,k,focusdir,up"
    "bind=SUPER,j,focusdir,down"

    # Move windows (Swap)
    "bind=SUPER+SHIFT,Left,exchange_client,left"
    "bind=SUPER+SHIFT,Right,exchange_client,right"
    "bind=SUPER+SHIFT,Up,exchange_client,up"
    "bind=SUPER+SHIFT,Down,exchange_client,down"
    "bind=SUPER+SHIFT,h,exchange_client,left"
    "bind=SUPER+SHIFT,l,exchange_client,right"
    "bind=SUPER+SHIFT,k,exchange_client,up"
    "bind=SUPER+SHIFT,j,exchange_client,down"

    # Workspaces (View tags)
    "bind=SUPER,1,view,1,0"
    "bind=SUPER,2,view,2,0"
    "bind=SUPER,3,view,3,0"
    "bind=SUPER,4,view,4,0"
    "bind=SUPER,5,view,5,0"
    "bind=SUPER,6,view,6,0"
    "bind=SUPER,7,view,7,0"
    "bind=SUPER,8,view,8,0"
    "bind=SUPER,9,view,9,0"
    "bind=SUPER,0,view,10,0" # Assuming 10 tags support

    # Move to workspace (Tag)
    "bind=SUPER+SHIFT,1,tag,1,0"
    "bind=SUPER+SHIFT,2,tag,2,0"
    "bind=SUPER+SHIFT,3,tag,3,0"
    "bind=SUPER+SHIFT,4,tag,4,0"
    "bind=SUPER+SHIFT,5,tag,5,0"
    "bind=SUPER+SHIFT,6,tag,6,0"
    "bind=SUPER+SHIFT,7,tag,7,0"
    "bind=SUPER+SHIFT,8,tag,8,0"
    "bind=SUPER+SHIFT,9,tag,9,0"
    "bind=SUPER+SHIFT,0,tag,10,0"

    # Resize
    "bind=SUPER,minus,resizewin,-100 0"
    "bind=SUPER,equal,resizewin,100 0"
    "bind=SUPER+SHIFT,minus,resizewin,0 -100"
    "bind=SUPER+SHIFT,equal,resizewin,0 100"

    # Floating
    "bind=SUPER,V,togglefloating,"
    "bind=SUPER+SHIFT,Return,togglefullscreen,"

    # Exit
    "bind=SUPER+SHIFT,Escape,quit,"

    # Mouse bindings
    "mousebind=SUPER,btn_left,moveresize,curmove"
    "mousebind=SUPER,btn_right,moveresize,curresize"

    # Reload config
    "bind=SUPER+SHIFT,c,reload_config,"
  ];

  configConf = ''
    # Generated Mangowc Config

    # Appearance
    border_radius=8
    borderpx=2
    gappih=5
    gappiv=5
    gappoh=5
    gappov=5

    # Input
    tap_to_click=1

    # Keybindings
    ${lib.concatStringsSep "\n" quickAppBindings}

    ${lib.concatStringsSep "\n" coreBindings}

    # Auto-generated from Hyprland bindings logic
    bind=SUPER,space,spawn,wofi --show drun --sort-order=alphabetical
    bind=SUPER+SHIFT,space,spawn,pkill -SIGUSR1 waybar
  '';

in {
  imports = [
    inputs.mangowc.homeManagerModules.mango
  ];

  config = lib.mkIf (cfg.desktop.environment == "mangowc") {
    wayland.windowManager.mango = {
      enable = true;
      settings = configConf;
      autostart_sh = ''
        waybar &
        swaybg -i ${(import ../../lib/selected-wallpaper.nix config).wallpaper_path} -m fill &
      '';
    };

    # Polkit agent is needed for Mangowc too?
    # Hyprland module had hyprpolkitagent.
    # Assuming we might want it or similar.
    services.hyprpolkitagent.enable = true;
  };
}
