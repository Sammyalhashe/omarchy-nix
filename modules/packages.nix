{
  pkgs,
  lib,
  exclude_packages ? [ ],
}:
let
  # Essential Hyprland packages - cannot be excluded
  hyprlandPackages = with pkgs; [
    hyprshot
    hyprpicker
    hyprsunset
    brightnessctl
    pamixer
    playerctl
    gnome-themes-extra
    pavucontrol
  ];

  # Essential system packages - cannot be excluded
  systemPackages = with pkgs; [
    alejandra
    blueberry
    clipse
    curl
    eza
    fd
    fzf
    git
    gnumake
    jq
    libnotify
    nautilus
    ripgrep
    unzip
    vim
    wget
    zoxide
  ];

  # Discretionary packages - can be excluded by user
  discretionaryPackages =
    with pkgs;
    [
      # TUIs
      lazygit
      lazydocker
      btop
      powertop
      fastfetch

      # GUIs
      chromium
      obsidian
      vlc
      signal-desktop

      # Development tools
      github-desktop
      gh

      # Containers
      docker-compose
      ffmpeg
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      # App images
      beeper
    ];

  # Only allow excluding discretionary packages to prevent breaking the system
  filteredDiscretionaryPackages = lib.lists.subtractLists exclude_packages discretionaryPackages;
  allSystemPackages = hyprlandPackages ++ systemPackages ++ filteredDiscretionaryPackages;
in
{
  # Regular packages
  systemPackages = allSystemPackages;

  homePackages = with pkgs; [
  ];
}
