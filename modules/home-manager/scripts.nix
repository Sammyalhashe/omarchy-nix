# {
#   browser ? "brave --new-window --ozone-platform=wayland",
# }:
{ pkgs, ... }:
let
  BOOKMARKS = ''
    [coding] https://github.com/Sammyalhashe
    [crypto] https://matcha.xyz
  '';
in
pkgs.writeShellScriptBin "wofi-bookmark" ''
  let chosen=`echo ${BOOKMARKS} | wofi --show=dmenu | awk '{ print $2 }'`

  if [[ ! $chosen ]]; then
    return
  fi

  exec "$1" $chosen
''
