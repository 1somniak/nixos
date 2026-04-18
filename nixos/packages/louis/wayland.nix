{ pkgs, ... }:

let
  vscode-nosandbox = pkgs.writeShellScriptBin "code" ''
    exec ${pkgs.vscode}/bin/code --no-sandbox "$@"
  '';
in
{
  users.users.louis.packages = with pkgs; [
    kitty       # Terminal
    wofi        # Lanceur d'application
    waybar      # Barre d'état
    dunst       # Notifications
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
    grim
    slurp
    hyprshot
    hyprlock
    sddm-astronaut

    wdisplays
    vscode-nosandbox # vscode-fhs but with --no-sandbox (to avoid "no new privileges" flag is set)
    zed-editor
  ];
}
