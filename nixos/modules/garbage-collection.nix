{ ... }:

{
  # Garbage collection
  boot.loader.systemd-boot.configurationLimit = 50;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
