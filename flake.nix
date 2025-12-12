{
  description = "Omarchy - Base configuration flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      hyprland,
      nix-colors,
      home-manager,
      hyprland-plugins,
      mangowc,
    }:
    {
      nixosModules = {
        default =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            imports = [
              (import ./modules/nixos/default.nix inputs)
            ];

            options.omarchy = (import ./config.nix lib).omarchyOptions;
            config = {
              nixpkgs.config.allowUnfree = true;
            };
          };
      };

      homeManagerModules = {
        default =
          {
            config,
            lib,
            pkgs,
            osConfig ? { },
            ...
          }:
          {
            imports = [
              nix-colors.homeManagerModules.default
              (import ./modules/home-manager/default.nix inputs)
            ];
            options.omarchy = (import ./config.nix lib).omarchyOptions;
            config = lib.mkIf (osConfig ? omarchy) {
              omarchy = osConfig.omarchy;
            };
          };
      };
    };
}
