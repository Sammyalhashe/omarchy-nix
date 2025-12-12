inputs: {
  config,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = config.omarchy.desktop.environment == "hyprland";
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland; # Use stable nixpkgs version to fix Qt version mismatch
  };
}
