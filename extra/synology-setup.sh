mkdir -p ~/Synology/
sudo mount -t nfs 192.168.4.44:/volume1 ~/Synology

# Give access... could be better...
sudo chmod -Rv +rwx Synology/
