{ pkgs, ... }:

{
  users.users.louis.packages = with pkgs; [
    man-db
    man-pages
    man-pages-posix

    brave
    chromium
    tor-browser
    unzip
    zip
    tree
    jq
    ncdu
    direnv
    peaclock

    xsel
    bc
    libreoffice
    emacs
    nix-tree
    grim
    slurp
    (pkgs."wl-clipboard")
    swappy
    transmission_4 # torrent download : "transmission-cli magnet:?..."
  ];
}
