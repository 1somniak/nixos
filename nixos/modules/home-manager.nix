{ ... }:

let
  dotfiles = ../../dotfiles;
in
{
  home-manager.users.louis = { ... }:
  {
    home.stateVersion = "24.11";
    programs.waybar.enable = true;
    programs.git.settings.user = {
      enable = true;
      name = "Louis Rodet";
      email = "louis.rodet@epita.fr";
    };

    # Editor
    home.file.".vimrc".source = dotfiles + "/editor/.vimrc";

    # hypr
    xdg.configFile."hypr/hyprland.conf".source = dotfiles + "/hypr/hyprland.conf";
    xdg.configFile."hypr/hyprlock.conf".source = dotfiles + "/hypr/hyprlock.conf";
    xdg.configFile."hypr/hyprpaper.conf".source = dotfiles + "/hypr/hyprpaper.conf";
    xdg.configFile."hypr/wallpapers".source = dotfiles + "/hypr/wallpapers";

    # Rofi
    xdg.configFile."rofi/config.rasi".source = dotfiles + "/rofi/config.rasi";
    xdg.configFile."rofi/themes/calm.rasi".source = dotfiles + "/rofi/calm.rasi";

    # Shell
    home.file.".zsh-powerline.sh".source = dotfiles + "/shell/.zsh-powerline.sh";
    home.file.".zshrc".source = dotfiles + "/shell/.zshrc";

    # Waybar
    xdg.configFile."waybar/config".source = dotfiles + "/waybar/config";
    xdg.configFile."waybar/style.css".source = dotfiles + "/waybar/style.css";
    xdg.configFile."waybar/switch-audio-sink.sh" = {
      source = dotfiles + "/waybar/switch-audio-sink.sh";
      executable = true;
    };
  };
}
