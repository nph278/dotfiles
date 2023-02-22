mount $1 /mnt

# Org-roam
rm -rf /mnt/Roam
cp -r /home/carl/Roam /mnt/Roam
rm -f /mnt/org-roam.db
cp /home/carl/.emacs.d/org-roam.db /mnt/org-roam.db

umount /mnt
