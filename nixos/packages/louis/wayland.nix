{ pkgs, ... }:

{
  users.users.louis.packages = with pkgs; [
    kitty       # Terminal
    wofi        # Lanceur d'application
    waybar      # Barre d'état
    swaynotificationcenter      # Notifications
    libnotify   # Utilitaire notify-send
    wl-clipboard
    pavucontrol
    papirus-icon-theme
    hyprpaper
    vanilla-dmz
    nwg-look
    swayosd
    eww                         # Widgets (athena-eww)
    brightnessctl               # Contrôle luminosité (pour eww)
    inotify-tools               # Surveillance de fichiers (pour eww todo)
    socat                       # Socket Hyprland (pour eww workspaces)

    kdePackages.dolphin
    kdePackages.koko

    flameshot
    hyprlock

    wdisplays

    # Matrix client
    cinny-desktop
    fluffychat
  ];
}
