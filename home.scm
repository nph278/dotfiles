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
	     (gnu packages shellutils)
	     (guix gexp)
	     (guix store)
	     (guix packages)
	     (ice-9 textual-ports)
	     (ice-9 string-fun))

(define (read-file filename) (call-with-input-file filename get-string-all))

(define (store-path package) (with-store store (package-output store package)))

(define shell-aliases '(

			;; ls
			("ls" . "ls --color")
			("l" . "ls -la")

			;; git
                        ("ga" . "git add -A")
                        ("gc" . "git commit -m")
                        ("gp" . "git push origin")
                        ("gg" . "git log --graph --pretty=oneline --abbrev-commit")
                        ("gl" . "git log --graph --pretty=short")
                        ("gac" . "ga && gc")
                        ("gf" . "git fetch")
                        ("gs" . "git status")
                        ("gd" . "git diff")

			;; Passwords
			("kee" . "keepassxc-cli open ~/.KeePass.kdbx")

			;; mpv
			("mpva" . "mpv --no-video")
			("mpvterm" . "DISPLAY= mpv -vo caca")

			;; guix
			("ghr" . "guix home reconfigure")
			("gsr" . "guix system reconfigure")
			("ghdg" . "guix home delete-generations")
			("gsdg" . "guix system delete-generations")
			("ggc" . "guix gc")

			;; Music
			("muspath" . "beet ls -f '$path'") ;; fix
                        ("musa" . "mpva \"$(muspath -a \"$(beet ls -f '$album' -a | fzf)\")\"")
                        ("muss" . "mpva \"$(muspath \"$(beet ls -f '$title' | fzf)\")\"")
                        ("muscrazy" . "mpva --shuffle ~/Music/")

			;; Other
			("rm" . "trash")))

(define bashrc (string-append
		"set -o vi\n"
		(apply string-append (map (lambda (a) (format #f "alias ~a='~a'\n" (car a) (string-replace-substring (cdr a) "'" "'\\''"))) shell-aliases))))

;; jasonm23/emacs-theme-kanagawa/master/kanagawa-theme.el

(home-environment
  (packages (list

	    ;; Admin
	    htop
	    neofetch
	    alacritty

	    ;; Utilities
	    ripgrep
	    fzf
	    trash-cli

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
	    emacs-geiser-guile
	    emacs-autothemer
	    emacs-paredit

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
			 (".emacs.d/init.el" ,(read-file "emacs/init.el"))

			 ;; Sway
			 (".config/sway/config" ,(read-file "sway/config"))

			 ;; Bash
			 (".bashrc" ,bashrc)))))))
