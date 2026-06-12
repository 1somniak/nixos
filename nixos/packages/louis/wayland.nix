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
