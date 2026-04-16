{ ... }:

{
  imports = [
    ./home/default.nix
    ./system/default.nix
    ./louis/default.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;
  programs.zsh.enable = true;
}
