{ ... }:

{
  networking.hostName = "nixos";
  networking.firewall.checkReversePath = false;

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  services.gnome.gnome-keyring.enable = false;
}
