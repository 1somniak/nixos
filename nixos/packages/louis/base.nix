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
    sl
    asciiquarium
    direnv
    cmatrix
    sssnake
    cowsay
    peaclock

    xsel
    bc
    libreoffice
    emacs
  ];
}
