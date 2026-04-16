{ ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Swapfile 24 Go
  swapDevices = [
    {
      device = "/swapfile";
      size = 24576; # size in MB (24 GB)
    }
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;  # Interface graphique
}
