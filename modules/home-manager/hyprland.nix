inputs:
{
  config,
  pkgs,
  ...
}:
let
  cfg = config.omarchy;
in
{
  imports = [ ./hyprland/configuration.nix ];
  wayland.windowManager.hyprland = {
    enable = cfg.desktop.environment == "hyprland";
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprscrolling
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
  };
  services.hyprpolkitagent.enable = cfg.desktop.environment == "hyprland";
}
