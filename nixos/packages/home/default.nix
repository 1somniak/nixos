{ pkgs, ... }:

{
  home-manager.users.louis.home.packages = with pkgs; [
    fastfetch
    btop
    rofi
  ];
}
