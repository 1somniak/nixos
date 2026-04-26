{ pkgs, ... }:

{
  # --- CONFIGURATION GRAPHIQUE & HYPRLAND ---

  # garder X11 activé pour la gestion du clavier au login
  services.xserver.enable = true;

  # Configuration du clavier
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };
  console.keyMap = "fr";

  services.flatpak.enable = true;

  # Gestionnaire de connexion: greetd + tuigreet (login direct sans clic)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "env XKB_DEFAULT_LAYOUT=fr XKB_DEFAULT_VARIANT=azerty ${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --cmd start-hyprland";
        user = "greeter";
      };
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

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
}
