-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("caelestia shell -d")
    hl.exec_cmd("~/.config/check-updates-nixos.sh")     -- Check for flake updates on startup
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("~/.config/background.sh")

    hl.exec_cmd("hyprctl setcursor Vanilla-DMZ 24")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'")
end)
