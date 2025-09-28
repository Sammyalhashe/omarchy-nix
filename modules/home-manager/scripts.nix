{
  pkgs,
  ...
}:
let
  BOOKMARKS = "~/.bookmarks";
in
{

  wofi-bookmark = pkgs.writeShellScriptBin "wofi-bookmark" ''
    chosen=`cat ${BOOKMARKS} | wofi --show=dmenu | awk '{ print $2 }'`

    if [[ ! $chosen ]]; then
      return
    fi

    exec "$1" $chosen
  '';

  wofi-search-browser = pkgs.writeShellScriptBin "wofi-search-browser" ''

    # prompt for search query
    query=$(wofi --dmenu --prompt "brave search:")

    # exit if empty
    [ -z "$query" ] && exit

    # url encode function (requires jq)
    urlencode() {
        printf '%s' "$1" | jq -sRr @uri
    }

    if [[ $query == !* ]]; then
        # turns out this is how you escape in nix
        prefix="''${query:1:1}"
        rest="''${query:2}"
        rest_trimmed="$(echo "$rest" | sed 's/^ *//')"
        case "$prefix" in
            g) search_url="https://www.google.com/search?q=$(urlencode "$rest_trimmed")" ;;
            b) search_url="https://search.brave.com/search?q=$(urlencode "$rest_trimmed")" ;;
            a) search_url="https://chat.openai.com/?q=$(urlencode "$rest_trimmed")" ;;
            n) search_url="https://search.nixos.org/packages?query=$(urlencode "$rest_trimmed")" ;;
            *) search_url="https://search.brave.com/search?q=$(urlencode "$query")" ;;
        esac
    else
        search_url="https://search.brave.com/search?q=$(urlencode "$query")"
    fi

    # check if brave is running
    if pgrep -x brave >/dev/null; then
        brave --new-tab "$search_url"
    else
        brave "$search_url" &
    fi
  '';
}
