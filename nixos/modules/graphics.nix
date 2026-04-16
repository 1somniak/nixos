{ pkgs, ... }:

{
  # --- CONFIGURATION GRAPHIQUE & HYPRLAND ---

  # garder X11 activé pour la gestion du clavier au login (SDDM)
  services.xserver.enable = true;

  # Configuration du clavier
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };
  console.keyMap = "fr";

  services.flatpak.enable = true;

  # Le Gestionnaire de Connexion (Login Screen)
  services.displayManager = {
    sddm = {
      wayland.enable = true;
      enable = true;
      theme = "catppuccin-mocha-mauve";
    };
  };

  # Activation de Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # logind - ne rien faire à la fermeture du capot (ne pas déco le wifi)
  services.logind.settings.Login.HandleLidSwitch = "ignore";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  services.logind.settings.Login.IdleAction = "ignore"; # Ne pas faire d'action au timeout d'inactivité

  # Accélération graphique (pour Hyprland + Intel)
  hardware.graphics.enable = true;
  
  # Polices d'écriture
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}
