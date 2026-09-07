{ inputs, ... }:

let
  dotfiles = ../../dotfiles;
in
{
  home-manager.backupFileExtension = "backup";

  home-manager.users.louis = { config, pkgs, ... }:
  {
    home.stateVersion = "24.11";

    # Préférence globale de thème sombre (portails XDG, navigateurs web, apps Electron)
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
      };
    };

    # Thème GTK en mode sombre (GTK3 & GTK4)
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      gtk4.theme = config.gtk.theme;
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    # Thème Qt en mode sombre (Dolphin, etc.)
    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };

    imports = [ inputs.caelestia-shell.homeManagerModules.default ];
    programs.caelestia = {
      enable = true;
      cli.enable = true;
    };
    programs.git.settings.user = {
      enable = true;
      name = "Louis Rodet";
      email = "louis.rodet@epita.fr";
    };

    home.file.".face".source = dotfiles + "/louis.png";

    # Caelestia
    xdg.configFile."caelestia/shell.json".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/caelestia/shell.json";
    xdg.configFile."caelestia/cli.json".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/caelestia/cli.json";

    # Editor
    home.file.".vimrc".source = dotfiles + "/editor/.vimrc";

    # hypr
    xdg.configFile."hypr/hyprland.lua".source = dotfiles + "/hypr/hyprland.lua";
    xdg.configFile."hypr/hyprland".source = dotfiles + "/hypr/hyprland";
    xdg.configFile."hypr/hyprpaper.conf".source = dotfiles + "/hypr/hyprpaper.conf";
    xdg.configFile."hypr/wallpapers".source = dotfiles + "/hypr/wallpapers";
    xdg.configFile."hypr/screenshot-edit.sh" = {
      source = dotfiles + "/hypr/screenshot-edit.sh";
      executable = true;
    };



    # Shell
    home.file.".zsh-powerline.sh".source = dotfiles + "/shell/.zsh-powerline.sh";
    xdg.configFile."background.sh" = {
      source = dotfiles + "/shell/background.sh";
      executable = true;
    };
    xdg.configFile."check-updates-nixos.sh" = {
      source = dotfiles + "/shell/check-updates-nixos.sh";
      executable = true;
    };

    # Fastfetch
    xdg.configFile."fastfetch/config.jsonc".source = dotfiles + "/fastfetch/config.jsonc";
    xdg.configFile."fastfetch/logo.txt".source = dotfiles + "/fastfetch/logo.txt";



    # mario
    xdg.configFile."mario".source = dotfiles + "/mario";
  };
}
