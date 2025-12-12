inputs: {
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.mangowc.nixosModules.mango
  ];

  programs.mango = {
    enable = config.omarchy.desktop.environment == "mangowc";
  };
}
