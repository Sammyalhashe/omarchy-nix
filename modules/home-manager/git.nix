{ config, ... }:
let
  cfg = config.omarchy;
in
{
  programs.git = {
    enable = true;
    settings = {

      credential.helper = "store";
      user = {
        name = cfg.full_name;
        email = cfg.full_name;
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };
}
