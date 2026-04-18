{ pkgs, ... }:

{
  home-manager.users.louis = {
    imports = [
      ./zsh.nix
    ];

    home.packages = with pkgs; [
    fastfetch
    btop
    rofi
  ];
  };
}
