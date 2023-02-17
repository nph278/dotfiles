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
	     (gnu packages rust)
	     (gnu packages rust-apps)
	     (gnu packages emacs)
	     (gnu packages emacs-xyz)
	     (guix gexp)
	     (ice-9 textual-ports))

(define (read-file filename) (call-with-input-file filename get-string-all))

(home-environment
  (packages (list

	    ;; Admin
	    htop
	    neofetch
	    alacritty

	    ;; Utilities
	    ripgrep

	    ;; Sway
	    sway
	    swaylock
	    grimshot
	    wl-clipboard
	    
	    ;; Passwords
	    keepassxc

	    ;; Web
	    qutebrowser
	    vimb

	    ;; Media
	    beets
	    mpv

	    ;; Editing/Creation
	    gimp

	    ;; Development
	    git
	    openssh

	    ;; Rust
	    rust
	    (list rust "cargo")
	    (list rust "rustfmt")

	    ;; Emacs
	    emacs
	    emacs-evil
	    emacs-geiser

	    ;; Fonts
	    font-google-noto
	    font-google-noto-emoji
	    font-google-noto-sans-cjk
	    font-victor-mono))
 (services
  (list
   (simple-service 'configuration-files
		   home-files-service-type

		   (map (lambda (x)
			 (define filename (car x))
			 (define contents (car (cdr x)))
			 (list filename (plain-file "config-file" contents)))
			`(

			 ;; mpv
			 (".config/mpv/mpv.conf" ,(read-file "mpv/mpv.conf"))
			 (".config/mpv/input.conf" ,(read-file "mpv/input.conf"))

			 ;; Emacs
			 (".emacs.d/init.el" ,(read-file "emacs/init.el"))))))))
