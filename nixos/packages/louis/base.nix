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
    direnv
    peaclock

    xsel
    bc
    libreoffice
    emacs
  ];
}
