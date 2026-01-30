# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./wifi.nix
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
  services.displayManager.sddm = {
      enable = true;
      wayland.enable = true; # Mode Wayland pour SDDM
      theme = "breeze";
  };

  # Activation de KDE Plasma
  services.desktopManager.plasma6.enable = true;

  # Accélération graphique (Indispensable pour Nixos + Intel)
  hardware.graphics.enable = true;
  
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;  # Interface graphique

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

  users.users.louis = {
    isNormalUser = true;
    description = "louis";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
        kitty
        pavucontrol # pour le son
        brave
        unzip
        zip
        tree
        papirus-icon-theme
        vscode-fhs
        xsel
        libreoffice
        wl-clipboard  # Gestion du presse-papier

        gcc
        rocmPackages.llvm.clang-unwrapped # clang format

        typst
        python3
        nodejs_24
    ];
  };


  environment.shellAliases = {
    code = "code --ozone-platform=wayland"; # pour avoir vscode net
  };

  environment.sessionVariables = {
    TERMINAL = "kitty";
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
    #pkgsStable.protonvpn-gui
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
  };

  home.file.".config/kglobalshortcutsrc" = {
    source = ./.config/kglobalshortcutsrc;
  };
}
