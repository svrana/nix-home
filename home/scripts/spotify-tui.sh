hostname=$(cat /etc/hostname)
exec alacritty --title Spotify --class Spotify --config-file "/home/shaw/.dotfiles/configs/alacritty/alacritty.yml-spotify-tui.${hostname}" -e /home/shaw/.cargo/bin/spt
