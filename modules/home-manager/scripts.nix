# {
#   browser ? "brave --new-window --ozone-platform=wayland",
# }:
{
  pkgs,
  ...
}:
let
  BOOKMARKS = "~/.bookmarks";
in
pkgs.writeShellScriptBin "wofi-bookmark" ''
  let chosen=`cat ${BOOKMARKS} | wofi --show=dmenu | awk '{ print $2 }'`

  if [[ ! $chosen ]]; then
    return
  fi

  exec "$1" $chosen
''
