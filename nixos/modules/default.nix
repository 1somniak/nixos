{ ... }:

{
  imports = [
    ./nix-settings.nix
    ./networking.nix
    ./locale.nix
    ./users.nix
    ./environment.nix
    ./hardware.nix
    ./graphics.nix
    ./services.nix
    ./virtualisation.nix
    ./garbage-collection.nix
    ./home-manager.nix
  ];
}
