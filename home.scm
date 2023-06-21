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
	     (gnu packages cdrom)
	     (gnu packages image-viewers)
	     (gnu packages assembly)
	     (gnu packages compression)
	     (gnu packages cryptsetup)
	     (gnu packages libreoffice)
	     (gnu packages audio)
	     (gnu packages package-management)
	     (gnu packages virtualization)
	     (gnu packages graphics)
	     (gnu packages racket)
	     (guix gexp)
	     (guix store)
	     (guix packages)
	     (ice-9 textual-ports)
	     (ice-9 string-fun)
	     (system base compile))

(define (read-file filename) (call-with-input-file filename get-string-all))
(define (store-path package) (with-store store (package-output store package)))

(define shared-data (compile (call-with-input-file "./shared.el" read) #:from 'elisp))

;; Shared data
(define (d key)
  (cdr (assoc key shared-data)))

;; Color
(define (c color) (car (d color)))

(define shell-aliases
  '(

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
    ("muspath" . "beet ls -f '$path'")
    ("musa" . "mpva \"$(muspath -a \"$(beet ls -f '$album' -a | fzf)\")\"")
    ("muss" . "mpva \"$(muspath \"$(beet ls -f '$title' | fzf)\")\"")
    ("muscrazy" . "mpva --shuffle ~/Music/")

    ;; Other
    ("rm" . "trash")))

(define bashrc (string-append
		(read-file "./bash/vterm.sh")
		"set -o vi\n" ; VI mode
		(apply string-append (map (lambda (a) (format #f "alias ~a='~a'\n" (car a) (string-replace-substring (cdr a) "'" "'\\''"))) shell-aliases))))

(define sway-mod "Mod4")

(define sway-extra-config "
exec emacs --bg-daemon
exec swayidle -w \\
    timeout 300 'swaylock -f -c 000000' \\
    timeout 600 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' \\
    before-sleep 'swaylock -f -c 000000'
")

(define sway-font (string-append (d 'font-family) " Medium 12px"))

(define sway-options
  `(("floating_modifier" ,sway-mod "normal")
                       
    ;; Output
    ("output * bg" ,(c 'sumiInk-0) "solid_color")

    ;; Input
    ("input * natural_scroll enabled")
    ("input * middle_emulation enabled")
    ("input * xkb_options caps:escape")
    ("input * repeat_delay 200")
    ("input * repeat_rate 70")

    ;; Font
    ("font" ,sway-font)
                       
    ;; Border
    ;; "border pixel"
                       
    ;; Resize
    ("mode resize bindsym h resize shrink width 10px")
    ("mode resize bindsym j resize grow height 10px")
    ("mode resize bindsym k resize shrink height 10px")
    ("mode resize bindsym l resize grow width 10px")
    ("mode resize bindsym Return mode \"default\"")
    ("mode resize bindsym Escape mode \"default\"")

    ;; Client
    ("client.focused" ,(c 'crystalBlue) ,(c 'crystalBlue) ,(c 'sumiInk-0) ,(c 'springBlue) ,(c 'crystalBlue))
    ("client.focused_inactive" ,(c 'sumiInk-1b) ,(c 'sumiInk-1b) ,(c 'fujiWhite) ,(c 'springBlue) ,(c 'sumiInk-1b))
    ("client.unfocused" ,(c 'sumiInk-1b) ,(c 'sumiInk-1b) ,(c 'fujiWhite) ,(c 'springBlue) ,(c 'sumiInk-1b))
    ("client.urgent" ,(c 'peachRed) ,(c 'peachRed) ,(c 'sumiInk-0) ,(c 'springBlue) ,(c 'peachRed))
                       
    ;; Bar
    ("bar position top")
    ("bar font" ,sway-font)
    ("bar status_command while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done")
    ("bar colors background" ,(c 'sumiInk-0))
    ("bar colors statusline" ,(c 'fujiWhite))
    ("bar colors separator" ,(c 'sumiInk-0))
    ("bar colors focused_workspace" ,(c 'crystalBlue) ,(c 'crystalBlue) ,(c 'sumiInk-0))
    ("bar colors active_workspace" ,(c 'sumiInk-0) ,(c 'sumiInk-0) ,(c 'fujiWhite))
    ("bar colors inactive_workspace" ,(c 'sumiInk-0) ,(c 'sumiInk-0) ,(c 'fujiWhite))
    ("bar colors urgent_workspace" ,(c 'peachRed) ,(c 'peachRed) ,(c 'sumiInk-0))))

(define sway-keybinds
  (append '(;; Applications
	    ("Return" . "exec emacs --eval '(eshell)'")
	    ("q" . "exec qutebrowser --qt-flag disable-seccomp-filter-sandbox")
	    ("e" . "exec emacsclient -c")
	    ("Alt+e" . "exec kill $(ps -A | grep 'emacs-' | awk '{print $1;}') && emacs --bg-daemon")
	    ("x" . "exec bemenu-run")
	    ("Shift+x" . "exec flatpak run $(flatpak list --columns=application | bemenu)")
	    ("Alt+s" . "exec grimshot save screen")
	    ("Shift+s" . "exec grimshot save area")

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

(define (sway-option->string o)
  (apply string-append
	 (map (lambda (a)
		(string-append a " ")) o)))

(define sway-config
  (string-append (apply string-append (map (lambda (a) (format #f "bindsym ~a+~a ~a\n" sway-mod (car a) (cdr a))) sway-keybinds))
		 (apply string-append (map (lambda (a) (format #f "~a\n" (sway-option->string a))) sway-options))
		 sway-extra-config))

(define git-config "
[user]
  email = carllegrone@protonmail.com
  name = nph278
[core]
  excludesfile = ~/.global.gitignore   
")

(define minidlna-config
  (apply string-append
	 (map (lambda (x) (string-append (car x) "=" (cdr x) "\n"))
	      '(("media_dir" . "A,/home/carl/Music")
		("db_dir" . "/home/carl/.config/minidlna/db")
		("log_dir" . "/home/carl/.config/minidlna/log")
		("friendly_name" . "Vargomax V. Vargomax's Insane Collection")
		("inotify" . "yes")
		("presentation_url" . "http://192.168.1.5")))))

(define (equals-line a)
  (format #f "~a=~a\n" (car a) (cdr a)))

(define abcde-config
  (apply string-append
	 (map equals-line
	      '(("OUTPUTTYPE" . "flac")))))

(define mpv-config
  (apply string-append
	 (map equals-line
	      '(("osc" . "no")
		("volume" . "50")))))

(define mpv-input-config
  (apply string-append
	 (map (lambda (a) (string-append (string-join a " ") "\n"))
	      '(("h" "seek" "-2")
		("l" "seek" "2")
		("j" "add" "volume" "-2")
		("k" "add" "volume" "2")
		("J" "add" "speed" "-0.05")
		("K" "add" "speed" "0.05")))))

(define qutebrowser-options
  `(("url.default_page" . "about:blank")
    ("fonts.default_family" . ,(d 'font-family))
    ("fonts.web.family.fixed" . ,(d 'font-family))
    ("colors.completion.category.bg" . ,(c 'sumiInk-1b))
    ("colors.completion.category.fg" . ,(c 'fujiWhite))
    ("colors.completion.category.border.top" . ,(c 'sumiInk-1b))
    ("colors.completion.category.border.bottom" . ,(c 'sumiInk-1b))
    ("colors.completion.item.selected.bg" . ,(c 'crystalBlue))
    ("colors.completion.item.selected.fg" . ,(c 'sumiInk-0))
    ("colors.completion.item.selected.border.top" . ,(c 'crystalBlue))
    ("colors.completion.item.selected.border.bottom" . ,(c 'crystalBlue))
    ("colors.completion.match.fg" . ,(c 'fujiWhite))
    ("colors.completion.even.bg" . ,(c 'sumiInk-1b))
    ("colors.completion.odd.bg" . ,(c 'sumiInk-1b))
    ("colors.completion.fg" . ,(c 'fujiWhite))
    ("colors.completion.scrollbar.bg" . ,(c 'sumiInk-1b))
    ("colors.completion.scrollbar.fg" . ,(c 'fujiWhite))
    ("colors.contextmenu.disabled.bg" . ,(c 'sumiInk-1b))
    ("colors.contextmenu.disabled.fg" . ,(c 'peachRed))
    ("colors.contextmenu.menu.bg" . ,(c 'sumiInk-1b))
    ("colors.contextmenu.menu.fg" . ,(c 'fujiWhite))
    ("colors.contextmenu.selected.bg" . ,(c 'crystalBlue))
    ("colors.contextmenu.selected.fg" . ,(c 'fujiWhite))
    ("colors.downloads.bar.bg" . ,(c 'sumiInk-1b))
    ("colors.downloads.error.bg" . ,(c 'peachRed))
    ("colors.downloads.error.fg" . ,(c 'sumiInk-1b))
    ("colors.downloads.start.bg" . ,(c 'sumiInk-1b))
    ("colors.downloads.start.fg" . ,(c 'fujiWhite))
    ("colors.downloads.stop.bg" . ,(c 'sumiInk-1b))
    ("colors.downloads.stop.fg" . ,(c 'fujiWhite))
    ("colors.downloads.system.bg" . "rgb")
    ("colors.downloads.system.fg" . "rgb")
    ("colors.hints.bg" . ,(c 'surimiOrange))
    ("colors.hints.fg" . ,(c 'sumiInk-1b))
    ("colors.hints.match.fg" . ,(c 'sumiInk-2))
    ("colors.keyhint.bg" . ,(c 'surimiOrange))
    ("colors.keyhint.fg" . ,(c 'sumiInk-1b))
    ("colors.keyhint.suffix.fg" . ,(c 'sumiInk-1b))
    ("colors.messages.error.bg" . ,(c 'peachRed))
    ("colors.messages.error.border" . ,(c 'sumiInk-1b))
    ("colors.messages.error.fg" . ,(c 'sumiInk-1b))
    ("colors.messages.info.bg" . ,(c 'crystalBlue))
    ("colors.messages.info.border" . ,(c 'sumiInk-1b))
    ("colors.messages.info.fg" . ,(c 'sumiInk-1b))
    ("colors.messages.warning.bg" . ,(c 'surimiOrange))
    ("colors.messages.warning.border" . ,(c 'sumiInk-1b))
    ("colors.messages.warning.fg" . ,(c 'sumiInk-1b))
    ("colors.prompts.bg" . ,(c 'springGreen))
    ("colors.prompts.border" . ,(c 'sumiInk-1b))
    ("colors.prompts.fg" . ,(c 'sumiInk-1b))
    ("colors.prompts.selected.fg" . ,(c 'sumiInk-0))
    ("colors.prompts.selected.bg" . ,(c 'crystalBlue))
    ("colors.statusbar.caret.bg" . ,(c 'crystalBlue))
    ("colors.statusbar.caret.fg" . ,(c 'sumiInk-0))
    ("colors.statusbar.caret.selection.bg" . ,(c 'crystalBlue))
    ("colors.statusbar.caret.selection.fg" . ,(c 'sumiInk-0))
    ("colors.statusbar.command.bg" . ,(c 'sumiInk-1b))
    ("colors.statusbar.command.fg" . ,(c 'fujiWhite))
    ("colors.statusbar.command.private.bg" . ,(c 'sumiInk-1b))
    ("colors.statusbar.command.private.fg" . ,(c 'fujiWhite))
    ("colors.statusbar.insert.bg" . ,(c 'sumiInk-1b))
    ("colors.statusbar.insert.fg" . ,(c 'fujiWhite))
    ("colors.statusbar.normal.bg" . ,(c 'sumiInk-1b))
    ("colors.statusbar.normal.fg" . ,(c 'fujiWhite))
    ("colors.statusbar.passthrough.bg" . ,(c 'sumiInk-1b))
    ("colors.statusbar.passthrough.fg" . ,(c 'fujiWhite))
    ("colors.statusbar.private.bg" . ,(c 'sumiInk-1b))
    ("colors.statusbar.private.fg" . ,(c 'fujiWhite))
    ("colors.statusbar.progress.bg" . ,(c 'fujiWhite))
    ("colors.statusbar.url.error.fg" . ,(c 'peachRed))
    ("colors.statusbar.url.fg" . ,(c 'fujiWhite))
    ("colors.statusbar.url.hover.fg" . ,(c 'fujiWhite))
    ("colors.statusbar.url.success.http.fg" . ,(c 'peachRed))
    ("colors.statusbar.url.success.https.fg" . ,(c 'fujiWhite))
    ("colors.statusbar.url.warn.fg" . ,(c 'surimiOrange))
    ("colors.tabs.bar.bg" . ,(c 'crystalBlue))
    ("colors.tabs.even.bg" . ,(c 'sumiInk-1b))
    ("colors.tabs.even.fg" . ,(c 'fujiWhite))
    ("colors.tabs.indicator.error" . ,(c 'peachRed))
    ("colors.tabs.indicator.start" . ,(c 'crystalBlue))
    ("colors.tabs.indicator.stop" . ,(c 'springGreen))
    ("colors.tabs.indicator.system" . "rgb")
    ("colors.tabs.odd.bg" . ,(c 'sumiInk-1b))
    ("colors.tabs.odd.fg" . ,(c 'fujiWhite))
    ("colors.tabs.pinned.even.bg" . ,(c 'sumiInk-1b))
    ("colors.tabs.pinned.even.fg" . ,(c 'fujiWhite))
    ("colors.tabs.pinned.odd.bg" . ,(c 'sumiInk-1b))
    ("colors.tabs.pinned.odd.fg" . ,(c 'fujiWhite))
    ("colors.tabs.pinned.selected.even.bg" . ,(c 'crystalBlue))
    ("colors.tabs.pinned.selected.even.fg" . ,(c 'sumiInk-0))
    ("colors.tabs.pinned.selected.odd.bg" . ,(c 'crystalBlue))
    ("colors.tabs.pinned.selected.odd.fg" . ,(c 'sumiInk-0))
    ("colors.tabs.selected.even.bg" . ,(c 'crystalBlue))
    ("colors.tabs.selected.even.fg" . ,(c 'sumiInk-0))
    ("colors.tabs.selected.odd.bg" . ,(c 'crystalBlue))
    ("colors.tabs.selected.odd.fg" . ,(c 'sumiInk-0))
    ("colors.webpage.bg" . ,(c 'sumiInk-1b))
    ("colors.webpage.preferred_color_scheme" . "dark")
    ("content.blocking.enabled" . #t)
    ("content.blocking.adblock.lists" .
     ("https://easylist.to/easylist/easylist.txt"
      "https://easylist.to/easylist/easyprivacy.txt"
      "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt"
      "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2020.txt"
      "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/legacy.txt"
      "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt"
      "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt"
      "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt"
      "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=1&mimetype=plaintext&_=223428 "
      "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-lists/brave-social.txt"
      "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt"
      "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-unbreak.txt"))
    ("content.blocking.hosts.lists" . ("https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"))
    ("content.blocking.method" . "auto")
    ("auto_save.session" . #t)))

(define (expr->python e)
  (cond 
   [(string? e) (string-append "\"" e "\"")]
   [(boolean? e) (if e "True" "False")]
   [(number? e) (number->string e)]
   [(list? e) (apply string-append `("[" ,@(map (lambda (x) (string-append (expr->python x) ",")) e) "]"))]))

(define (qutebrowser-option->string o)
  (string-append "c." (car o) " = " (expr->python (cdr o)) "\n"))

(define qutebrowser-config
  (string-append (apply string-append
			(map qutebrowser-option->string qutebrowser-options))
		 "config.load_autoconfig(False)\n"))

(define config-files
  `( ;; mpv
    (".config/mpv/mpv.conf" . ,mpv-config)
    (".config/mpv/input.conf" . ,mpv-input-config)

    ;; Emacs
    (".emacs.d/init.el" . ,(read-file "emacs/init.el"))
    (".emacs.d/themes/kanagawa-theme.el" . ,(read-file "emacs/kanagawa-theme.el"))

    ;; Sway
    (".config/sway/config" . ,sway-config)

    ;; Bash
    (".bashrc" . ,bashrc)

    ;; Git
    (".gitconfig" . ,git-config)
    (".global.gitignore" . ,(read-file ".global.gitignore"))

    ;; Minidlna
    (".config/minidlna/minidlna.conf" . ,minidlna-config)

    ;; ABCDE
    (".abcde.conf" . ,abcde-config)

    ;; Qutebrowser
    (".config/qutebrowser/config.py" . ,qutebrowser-config)))

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
	    ripgrep
	    zip
	    unzip
	    cryptsetup

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
	    readymedia
	    mpv
	    ffmpeg
	    abcde
	    imv
	    glyr
	    audacity
	    yt-dlp
	    blender

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

	    ;; Assembly
	    fasm

	    ;; Racket
	    racket

	    ;; Flatpak
	    flatpak

	    ;; Vitrualization
	    qemu

	    ;; Emacs
	    emacs
	    emacs-evil
	    emacs-geiser
	    emacs-geiser-guile
	    emacs-racket-mode
	    emacs-autothemer
	    emacs-paredit
	    emacs-org
	    emacs-org-roam
	    emacs-org-fragtog
	    emacs-undo-tree
	    emacs-evil-org
	    emacs-evil-collection
	    emacs-multi-vterm
	    emacs-git-gutter-fringe
	    ;; emacs-perspective
	    emacs-rust-mode
	    emacs-ligature
	    emacs-consult
	    emacs-lua-mode
	    emacs-nov-el
	    emacs-auctex
	    emacs-pdf-tools
	    emacs-yaml-mode
	    emacs-guix

	    ;; Containers
	    ;; podman
	    ;; iptables

	    ;; Fonts
	    font-google-noto
	    font-google-noto-emoji
	    font-google-noto-sans-cjk
	    font-victor-mono

	    ;; Libreoffice
	    libreoffice))
 (services
  (list
   (simple-service 'configuration-files
		   home-files-service-type
		   (map (lambda (x)
			  (define filename (car x))
			  (define contents (cdr x))
			  (list filename (plain-file "config-file" contents)))
			config-files)))))
