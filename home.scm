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
	     (gnu packages containers)
	     (gnu packages linux)
	     (gnu packages pulseaudio)
	     (gnu packages tex)
	     (gnu packages python)
	     (gnu packages python-xyz)
	     (gnu packages speech)
	     (gnu packages upnp)
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

(define sway-mod "Mod4")

(define sway-extra-config "
exec swayidle -w \\
    timeout 300 'swaylock -f -c 000000' \\
    timeout 600 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' \\
    before-sleep 'swaylock -f -c 000000'
")

(define sway-options `(
                       ,(format #f "floating_modifier ~a normal" sway-mod)
                       
	               ;; Output
                       "output * bg #1f1f28 solid_color"

		       ;; Input
                       "input * natural_scroll enabled"
                       "input * middle_emulation enabled"
                       "input * xkb_options caps:escape"
                       "input * repeat_delay 200"
                       "input * repeat_rate 70"
                       
		       ;; Border
                       ;; "border pixel"
                       
		       ;; Resize
                       "mode resize bindsym h resize shrink width 10px"
                       "mode resize bindsym j resize grow height 10px"
                       "mode resize bindsym k resize shrink height 10px"
                       "mode resize bindsym l resize grow width 10px"
                       "mode resize bindsym Return mode \"default\""
                       "mode resize bindsym Escape mode \"default\""
                       
		       ;; Bar
                       "bar position top"
                       "bar status_command while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done"
                       "bar colors statusline #ffffff"
                       "bar colors background #323232"
                       "bar colors inactive_workspace #32323200 #32323200 #5c5c5c"))

(define sway-keybinds (append '(
				;; mod+a keybinds

				;; Applications
				("Return" . "exec emacs --eval '(eshell)'")
				("q" . "exec qutebrowser --qt-flag disable-seccomp-filter-sandbox")
				("e" . "exec emacs")
				("x" . "exec bemenu-run")
				("y" . "exec emacs --eval '(eww \"ddg.gg\")'")
				("Alt+s" . "exec grimshot save screen ~/Pictures")
				("Shift+s" . "exec grimshot save area ~/Pictures")

				;; Music
				("m" . "exec mpv \"$(beet ls -f '$path' \"$(beet ls -f '$title' | bemenu -i)\")\"")
				("Shift+m" . "exec mpv \"$(beet ls -a -f '$path' \"$(beet ls -a -f '$album' | bemenu -i)\")\"")
				("Alt+m" . "exec mpv --shuffle ~/Music")

				;; Windows
				("h" . "focus left")
				("j" . "focus down")
				("k" . "focus up")
				("l" . "focus right")
				("Shift+h" . "move left")
				("Shift+j" . "move down")
				("Shift+k" . "move up")
				("Shift+l" . "move right")

				;; Layout
				("b" . "splith")
				("v" . "splitv")
				("w" . "layout tabbed")
				("s" . "layout toggle split")
				("f" . "fullscreen")
				("Shift+space" . "floating toggle")
				("space" . "focus mode_toggle")
				("r" . "mode resize")

				;; Other
				("Shift+q" . "kill")
				("Shift+c" . "reload")
				("Shift+e" . "exec swaynag -t warning -m 'Exit?' -b 'Yes' 'swaymsg exit'"))
			       ;; Workspaces
			       (apply append (map (lambda (n) (list (cons (format #f "~a" n) (format #f "workspace number ~a" n))
								    (cons (format #f "Shift+~a" n) (format #f "move container to workspace number ~a" n))))
						  (iota 9 1)))))

(define sway-config (string-append
		     (apply string-append (map
					   (lambda (a) (format #f "bindsym ~a+~a ~a\n" sway-mod (car a) (cdr a)))
					   sway-keybinds))
		     (apply string-append (map (lambda (a) (format #f "~a\n" a)) sway-options))
		     sway-extra-config))

(define git-config "
[user]
  email = carllegrone@protonmail.com
  name = nph278
[core]
  excludesfile = ~/.global.gitignore   
")

;; jasonm23/emacs-theme-kanagawa/master/kanagawa-theme.el

(home-environment
 (packages (list

	    ;; Admin
	    htop
	    neofetch

	    ;; Utilities
	    ripgrep
	    fzf
	    trash-cli
	    bemenu

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
	    readymedia
	    mpv
	    ffmpeg

	    ;; Editing/Creation
	    gimp
	    texlive

	    ;; Development
	    git
	    openssh

	    ;; Rust
	    rust
	    (list rust "cargo")
	    (list rust "rustfmt")

	    ;; Python
	    python
	    python-numpy

	    ;; Emacs
	    emacs
	    emacs-evil
	    emacs-geiser
	    emacs-geiser-guile
	    emacs-autothemer
	    emacs-paredit
	    emacs-org
	    emacs-org-roam
	    emacs-org-fragtog
	    emacs-undo-tree
	    emacs-evil-org

	    ;; Containers
	    ;; podman
	    ;; iptables

	    ;; Fonts
	    font-google-noto
	    font-google-noto-emoji
	    font-google-noto-sans-cjk
	    font-victor-mono

	    ;; Other
	    espeak))
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
			  (".config/sway/config" ,sway-config)

			  ;; Bash
			  (".bashrc" ,bashrc)

			  ;; Git
			  (".gitconfig" ,git-config)
			  (".global.gitignore" ,(read-file ".global.gitignore"))))))))
