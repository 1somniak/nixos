{ pkgs, ... }:

{
  users.users.louis.packages = with pkgs; [
    sl
    cmatrix
    sssnake
    cowsay
  ];
}
