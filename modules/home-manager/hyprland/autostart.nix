{
  config,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      # "hypridle & mako & waybar & fcitx5"
      # "waybar"
      # "swaybg -i ~/.config/omarchy/current/background -m fill"
      "hyprsunset"
      "systemctl --user start hyprpolkitagent"
      "wl-clip-persist --clipboard regular & clipse -listen"

      # "dropbox-cli start"  # Uncomment to run Dropbox

      # hyprland-plugins
      # "hyprctl plugin load \"$HYPR_PLUGIN_DIR/lib/libhyprexpo.so\""
    ];

    exec = [
      "pkill -SIGUSR2 waybar || waybar"
    ];
  };
}
