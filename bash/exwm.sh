if [ $TERM == "linux" ]; then
    GUIX_DIR=$HOME/.guix-home/profile

    $GUIX_DIR/bin/xinit -- $GUIX_DIR/bin/Xorg :0 vt1 -keeptty \
		-configdir $GUIX_DIR/share/X11/xorg.conf.d \
		-modulepath $GUIX_DIR/lib/xorg/modules
fi
