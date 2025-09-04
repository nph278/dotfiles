GTK_THEME=Adwaita-dark

gsettings set org.gnome.desktop.interface gtk-theme $GTK_THEME
flatpak override --user --env=GTK_THEME=$GTK_THEME
