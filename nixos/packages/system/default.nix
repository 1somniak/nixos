{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    (catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
  ];
}
