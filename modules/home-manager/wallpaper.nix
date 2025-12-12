{
  config,
  pkgs,
  ...
}: let
  selected_wallpaper_path = (import ../../lib/selected-wallpaper.nix config).wallpaper_path;
  cfg = config.omarchy;
in {
  home.file = {
    "Pictures/Wallpapers" = {
      source = ../../config/themes/wallpapers;
      recursive = true;
    };
  };

  # Hyprland uses hyprpaper
  services.hyprpaper = {
    enable = cfg.desktop.environment == "hyprland";
    settings = {
      preload = [
        selected_wallpaper_path
      ];
      wallpaper = [
        ",${selected_wallpaper_path}"
      ];
    };
  };

  # Mangowc uses swaybg (started via autostart in mangowc.nix, but we ensure package is available)
  home.packages = lib.mkIf (cfg.desktop.environment == "mangowc") [
    pkgs.swaybg
  ];
}
