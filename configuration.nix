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
  networking.firewall.checkReversePath = false;

  # Enable networking
  networking.networkmanager.enable = true;

  # applet graphique pour le wifi
  programs.nm-applet.enable = true;

  # dire à PAM (le gestionnaire d'authentification)de déverrouiller le trousseau quand on se connecte.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;

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

  # Accélération graphique (Indispensable pour Hyprland + Intel)
  hardware.graphics.enable = true;
  
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;  # Interface graphique

  # Swapfile 24 Go
  swapDevices = [
    {
      device = "/swapfile";
      size = 24576; # size in MB (24 GB)
    }
  ];

  # Polices d'écriture (CRUCIAL pour avoir les icônes dans la barre)
  fonts.packages = with pkgs; [ # syntaxe pour unstable
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
  #fonts.packages = with pkgs; [ # syntaxe pour 24.11
  #  font-awesome
  #  (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  #];

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

  documentation.enable = true;
  documentation.man.enable = true;

  users.users.louis = {
    isNormalUser = true;
    description = "louis";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
        # KIT DE SURVIE HYPRLAND (Ne pas supprimer pour l'instant)
        man-db
        man-pages
        man-pages-posix
        kitty       # Terminal (Ton seul moyen de communiquer avec l'OS au début)
        wofi        # Lanceur d'application (Menu Démarrer)
        waybar      # Barre d'état (Heure, batterie...)
        dunst       # Notifications
        wl-clipboard # Pour que le copier-coller fonctionne
        pavucontrol # pour le son
        brave
        vlc
        unzip
        zip
        tree
        papirus-icon-theme
        hyprpaper  # wallpaper
        vanilla-dmz  # Le pack de curseurs
        nwg-look        # L'outil pour l'appliquer aux apps
        swayosd      # pour afficher le volume en flottant

        # outils a la con
        kdePackages.dolphin
        ncdu

        vscode-fhs
        xsel
        bc
        libreoffice
        emacs

        grim          # Le moteur de capture
        slurp         # Le sélecteur de zone
        wl-clipboard  # Gestion du presse-papier
        hyprshot      # Le script de confort pour Hyprland

        gcc
        rocmPackages.llvm.clang-unwrapped # clang format
        docker
        wdisplays     # Gestion des affichages externes

        typst
        python3
        nodejs_24

        qemu
        
        hyprlock      # Screen locker pour Hyprland
        sddm-astronaut
    ];
  };


  environment.shellAliases = {
    code = "code --ozone-platform=wayland"; # pour avoir vscode net
  };

  environment.variables = {
  };

  # --- PROGRAMMES ---

  # Navigateur Web
  programs.firefox.enable = true;

  # Shell
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # --- PAQUETS SYSTÈME ---
  environment.systemPackages = [
    pkgs.vim 
    pkgs.wget
    pkgs.git
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
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
      rofi
    ];
  
    programs.git.settings.user = {
      enable = true;
      name  = "Louis Rodet";
      email = "louis.rodet@epita.fr";
    };
  
    # nixpkgs.config.allowUnfree = true; 
    xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/hyprland.conf; # Hyprland
    xdg.configFile."waybar/config".source = ./dotfiles/waybar-config; # Waybar (Fichier config)
    xdg.configFile."waybar/style.css".source = ./dotfiles/waybar-style.css; # Waybar (Fichier css)
    xdg.configFile."waybar/switch-audio-sink.sh" = {
      source = ./dotfiles/switch-audio-sink.sh;
      executable = true;
    };
    xdg.configFile."rofi/config.rasi".source = ./dotfiles/rofi/config.rasi; # Rofi config
    xdg.configFile."rofi/themes/calm.rasi".source = ./dotfiles/rofi/calm.rasi; # Rofi theme
    xdg.configFile."hypr/hyprlock.conf".source = ./dotfiles/hyprlock.conf; # Hyprlock (Screen locker)
    xdg.configFile."hypr/hyprpaper.conf".source = ./dotfiles/hyprpaper.conf; # Hyprpaper (Wallpaper)
    xdg.configFile."hypr/wallpapers".source = ./dotfiles/wallpapers;
    
    # (Optionnel) Pour s'assurer que Waybar est bien géré
    programs.waybar.enable = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
