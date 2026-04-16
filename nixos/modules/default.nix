{ ... }:

{
  imports = [
    ./hardware.nix
    ./graphics.nix
    ./services.nix
    ./virtualisation.nix
    ./garbage-collection.nix
  ];
}
