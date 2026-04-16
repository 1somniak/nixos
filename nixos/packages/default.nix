{ ... }:

{
  imports = [
    ./home/default.nix
    ./system/default.nix
    ./louis/default.nix
  ];

  programs.firefox.enable = true;
  programs.zsh.enable = true;
}
