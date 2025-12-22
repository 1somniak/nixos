# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #<home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # auto connect pour arpej
  networking.networkmanager.ensureProfiles.profiles = {
    numericable = {
      connection = {
        id = "Numericable-af2e";
        type = "wifi";
        interface-name = "wlp0s20f3"; 
      };
      wifi = {
        ssid = "Numericable-af2e";
        mode = "infrastructure";
      };
      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = "y12k5kkvzzkn";
      };
      ipv4 = { method = "auto"; };
      ipv6 = { method = "auto"; };
    };
  };
  
  # Enable networking
  networking.networkmanager.enable = true;

  # Flakes sont toujours utiles
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # --- CONFIGURATION GRAPHIQUE & HYPRLAND ---

  # On garde X11 activé pour la gestion du clavier au login (SDDM)
  services.xserver.enable = true;

  # Configuration du clavier (AZERTY)
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };
  console.keyMap = "fr";

  # Le Gestionnaire de Connexion (Login Screen)
  services.displayManager.sddm = {
      enable = true;
      wayland.enable = true; # Mode Wayland pour SDDM
      theme = "breeze";
  };

  # Activation de Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Accélération graphique (Indispensable pour Hyprland + Intel)
  hardware.graphics.enable = true;
  
  # Polices d'écriture (CRUCIAL pour avoir les icônes dans la barre)
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # --- SON ---
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- UTILISATEUR ---
  users.defaultUserShell = pkgs.zsh;

  users.users.louis = {
    isNormalUser = true;
    description = "louis";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
        # KIT DE SURVIE HYPRLAND (Ne pas supprimer pour l'instant)
        kitty       # Terminal (Ton seul moyen de communiquer avec l'OS au début)
        wofi        # Lanceur d'application (Menu Démarrer)
        waybar      # Barre d'état (Heure, batterie...)
        dunst       # Notifications
        wl-clipboard # Pour que le copier-coller fonctionne
        pavucontrol # pour le son
        brave
        protonvpn-gui
        papirus-icon-theme
        hyprpaper  # wallpaper
        vanilla-dmz  # Le pack de curseurs
        nwg-look        # L'outil pour l'appliquer aux apps
        swayosd      # pour afficher le volume en flottant

        vscode
    ];
  };


  environment.shellAliases = {
    code = "code --ozone-platform=wayland"; # pour avoir vscode net
  };

  # --- PROGRAMMES ---

  # Navigateur Web
  programs.firefox.enable = true;

  # Shell
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # --- PAQUETS SYSTÈME ---
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
  ];

  # Ne change pas cette version
  system.stateVersion = "24.11"; 

  # --- CONFIGURATION HOME MANAGER ---
  home-manager.useGlobalPkgs = true;
  home-manager.users.louis = { pkgs, ... }:
  {
    home.stateVersion = "24.11";
    home.packages = with pkgs; [
      fastfetch
      btop
    ];
  
    programs.git.settings.user = {
      enable = true;
      name  = "Louis Rodet";
      email = "louis.rodet@epita.fr";
    };
  
    # (Optionnel) Autorise les logiciels non-libres
    # nixpkgs.config.allowUnfree = true; 
    xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/hyprland.conf; # Hyprland
    
    xdg.configFile."waybar/config".source = ./dotfiles/waybar-config; # Waybar (Fichier config)
    xdg.configFile."waybar/style.css".source = ./dotfiles/waybar-style.css; # Waybar (Fichier css)
    
    # (Optionnel) Pour s'assurer que Waybar est bien géré
    programs.waybar.enable = true;
  };
}
