{ ... }:

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

    xdg.configFile."hypr/hyprland.conf".source = ../../dotfiles/hyprland.conf;
    xdg.configFile."waybar/config".source = ../../dotfiles/waybar-config;
    xdg.configFile."waybar/style.css".source = ../../dotfiles/waybar-style.css;
    xdg.configFile."waybar/switch-audio-sink.sh" = {
      source = ../../dotfiles/switch-audio-sink.sh;
      executable = true;
    };
    xdg.configFile."rofi/config.rasi".source = ../../dotfiles/rofi/config.rasi;
    xdg.configFile."rofi/themes/calm.rasi".source = ../../dotfiles/rofi/calm.rasi;
    xdg.configFile."hypr/hyprlock.conf".source = ../../dotfiles/hyprlock.conf;
    xdg.configFile."hypr/hyprpaper.conf".source = ../../dotfiles/hyprpaper.conf;
    xdg.configFile."hypr/wallpapers".source = ../../dotfiles/wallpapers;

    home.file.".zsh-powerline.sh".source = ../../dotfiles/.zsh-powerline.sh;
    home.file.".zshrc".source = ../../dotfiles/.zshrc;
    home.file.".vimrc".source = ../../dotfiles/.vimrc;
  };
}
