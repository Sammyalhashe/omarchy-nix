inputs:
{
  config,
  pkgs,
  ...
}:
{
  imports = [ ./hyprland/configuration.nix ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    pkgs.hyprlandPlugins.hyprscrolling = {
      settings = {
        column_width = 0.5;
        fullscreen_on_one_column = false;
      };
    };
  };
  services.hyprpolkitagent.enable = true;
}
