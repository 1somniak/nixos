{ pkgs, ... }:

{
  # --- SON ---
  services.pulseaudio.enable = false;
  services.postgresql.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.tor = {
    enable = true;
    openFirewall = true;
  };

  # DMS Dependencies
  services.accounts-daemon.enable = true;
  services.power-profiles-daemon.enable = true;
  
  # Caelestia Dependencies
  services.upower.enable = true;
}
