{ pkgs, ... }:

{
  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Enable silent mode
    consoleLogLevel = 0;
    kernelParams = [
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  # Swapfile 8 Go
  swapDevices = [
    {
      device = "/swapfile";
      size = 8192; # size in MB (8 GB)
    }
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;  # Interface graphique
}
