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
    plugins = [
      pkgs.hyprlandPlugins.hyprscrolling
    ];
  };
  services.hyprpolkitagent.enable = true;
}
