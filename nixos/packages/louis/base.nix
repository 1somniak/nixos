{ pkgs, ... }:

{
  users.users.louis.packages = with pkgs; [
    man-db
    man-pages
    man-pages-posix

    brave
    unzip
    zip
    tree
    jq
    ncdu
    asciiquarium
    direnv
    peaclock

    xsel
    bc
    libreoffice
    emacs
  ];
}
