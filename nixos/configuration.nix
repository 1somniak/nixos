# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./packages/default.nix
      ./modules/default.nix
    ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.firewall.checkReversePath = false;

  # Enable networking
  networking.networkmanager.enable = true;

  # applet graphique pour le wifi
  programs.nm-applet.enable = true;

  # dire à PAM (le gestionnaire d'authentification)de déverrouiller le trousseau quand on se connecte.
  services.gnome.gnome-keyring.enable = false;

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

  # --- UTILISATEUR ---
  users.defaultUserShell = pkgs.zsh;

  documentation.enable = true;
  documentation.man.enable = true;

  users.users.louis = {
    isNormalUser = true;
    description = "louis";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };


  environment.shellAliases = {
    code = "code --ozone-platform=wayland"; # pour avoir vscode net
  };

  environment.variables = {
  };

  # Ne change pas cette version
  system.stateVersion = "24.11"; 

  # --- CONFIGURATION HOME MANAGER ---
  home-manager.useGlobalPkgs = true;
  home-manager.users.louis = { pkgs, ... }:
  {
    home.stateVersion = "24.11";
    programs.git.settings.user = {
      enable = true;
      name  = "Louis Rodet";
      email = "louis.rodet@epita.fr";
    };
  
    # nixpkgs.config.allowUnfree = true; 
    xdg.configFile."hypr/hyprland.conf".source = ../dotfiles/hyprland.conf; # Hyprland
    xdg.configFile."waybar/config".source = ../dotfiles/waybar-config; # Waybar (Fichier config)
    xdg.configFile."waybar/style.css".source = ../dotfiles/waybar-style.css; # Waybar (Fichier css)
    xdg.configFile."waybar/switch-audio-sink.sh" = {
      source = ../dotfiles/switch-audio-sink.sh;
      executable = true;
    };
    xdg.configFile."rofi/config.rasi".source = ../dotfiles/rofi/config.rasi; # Rofi config
    xdg.configFile."rofi/themes/calm.rasi".source = ../dotfiles/rofi/calm.rasi; # Rofi theme
    xdg.configFile."hypr/hyprlock.conf".source = ../dotfiles/hyprlock.conf; # Hyprlock (Screen locker)
    xdg.configFile."hypr/hyprpaper.conf".source = ../dotfiles/hyprpaper.conf; # Hyprpaper (Wallpaper)
    xdg.configFile."hypr/wallpapers".source = ../dotfiles/wallpapers;
    home.file.".zsh-powerline.sh".source = ../dotfiles/.zsh-powerline.sh;
    home.file.".zshrc".source = ../dotfiles/.zshrc;
    home.file.".vimrc".source = ../dotfiles/.vimrc;
  };
}
