{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    inter
    fira-code
  ];
}
