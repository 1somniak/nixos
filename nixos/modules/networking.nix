{ ... }:

{
  networking.hostName = "nixos";
  networking.firewall.checkReversePath = false;

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = false;

  services.gnome.gnome-keyring.enable = true;
}
