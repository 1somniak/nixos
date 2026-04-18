{ config, pkgs, ... }:

let
  astronaut-theme = pkgs.stdenv.mkDerivation {
    name = "sddm-astronaut-theme";

    src = pkgs.fetchFromGitHub {
      owner = "Keyitdev";
      repo = "sddm-astronaut-theme";
      rev = "master";
      sha256 = "sha256-+94WVxOWfVhIEiVNWwnNBRmN+d1kbZCIF10Gjorea9M=";
    };

    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -r . $out/share/sddm/themes/sddm-astronaut-theme

      substituteInPlace $out/share/sddm/themes/sddm-astronaut-theme/metadata.desktop \
        --replace "ConfigFile=Themes/astronaut.conf" "ConfigFile=Themes/japanese_aesthetic.conf" \
        --replace "Screenshot=Previews/astronaut.png" "Screenshot=Backgrounds/japanese_aesthetic.png"

      theme_conf="$(find $out/share/sddm/themes/sddm-astronaut-theme -type f -name theme.conf | head -n1 || true)"
      if [ -n "$theme_conf" ]; then
        substituteInPlace "$theme_conf" \
          --replace "BackgroundType=video" "BackgroundType=image"
      fi
    '';
  };
in
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
      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs; [
        qt6.qtmultimedia
      ];
    };
  };

  environment.systemPackages = [
    astronaut-theme
  ];

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
