{ config, pkgs, ... }:

let
  louisPackages = with pkgs; [
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
    ffmpeg
    unzip
    zip
    tree
    jq
    papirus-icon-theme
    hyprpaper  # wallpaper
    vanilla-dmz  # Le pack de curseurs
    nwg-look        # L'outil pour l'appliquer aux apps
    swayosd      # pour afficher le volume en flottant

    # outils a la con
    kdePackages.dolphin
    kdePackages.koko
    ncdu
    sl
    asciiquarium
    flameshot # capture d'ecran
    direnv
    cmatrix
    sssnake
    cowsay
    peaclock

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
    bison
    flex
    fontforge
    makeWrapper
    pkg-config
    gnumake
    libiconv
    autoconf
    automake
    libtool # freetype calls glibtoolize
    criterion
    pre-commit
    libpcap
    pkg-config
    bear
    gdb
    pkgs.llvmPackages_20.clang-unwrapped

    rocmPackages.llvm.clang-unwrapped # clang format
    docker
    wdisplays     # Gestion des affichages externes

    typst
    (python3.withPackages (ps: with ps; [
      numpy
      pandas
      scipy
      plotly
      requests
    ]))
    nodejs_24

    qemu
    kvmtool
    
    hyprlock      # Screen locker pour Hyprland
    sddm-astronaut

    hugo

    # jetbrains
    # jetbrains-toolbox
    jetbrains.idea

    jdk21_headless # java
    maven

    postgresql

    #cracking
    file
    ghidra
    wineWowPackages.stable #pour lancer des binaires windows
  ];

  systemPackages = with pkgs; [
    vim
    wget
    git
    (catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
  ];

  homePackages = with pkgs; [
    fastfetch
    btop
    rofi
  ];
in
{
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  services.postgresql.enable = true;

  environment.systemPackages = systemPackages;
  users.users.louis.packages = louisPackages;

  home-manager.users.louis.home.packages = homePackages;
  home-manager.users.louis.programs.waybar.enable = true;
}
