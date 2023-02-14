(use-modules (gnu home)
	     (gnu home services)
	     (gnu home services fontutils)
	     (gnu services)
	     (gnu packages admin)
	     (gnu packages wm)
	     (gnu packages terminals)
	     (gnu packages password-utils)
	     (gnu packages web-browsers)
	     (gnu packages xdisorg)
	     (gnu packages music)
	     (gnu packages video)
	     (gnu packages version-control)
	     (gnu packages fonts)
	     (gnu packages gimp)
	     (gnu packages ssh)
	     (guix gexp))

(home-environment
  (packages (list

	    ;; Admin
	    htop
	    neofetch
	    alacritty

	    ;; Sway
	    sway
	    swaylock
	    grimshot
	    wl-clipboard
	    
	    ;; Passwords
	    keepassxc

	    ;; Web
	    qutebrowser

	    ;; Media
	    beets
	    mpv

	    ;; Editing/Creation
	    gimp

	    ;; Development
	    git
	    openssh

	    ;; Fonts
	    font-google-noto
	    font-google-noto-emoji
	    font-google-noto-sans-cjk
	    font-victor-mono))
 (services
  (list
   (simple-service 'configuration-files
		   home-xdg-configuration-files-service-type

		   (map (lambda (x)
			 (define filename (car x))
			 (define contents (car (cdr x)))
			 (list filename (plain-file "config-file" contents)))
			'(

			 ;; MPV
			 ("mpv/mpv.conf" "osc=no")
			 ("mpv/input.conf" "h seek -2
					    l seek 2
					    j add volume -2
					    k add volume 2
					    J add speed -0.05
					    K add speed 0.05")))))))
