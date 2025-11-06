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
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprscrolling
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
  };
  services.hyprpolkitagent.enable = true;
}
