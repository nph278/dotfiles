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
	     (ice-9 string-fun))

(define (read-file filename) (call-with-input-file filename get-string-all))

(define (store-path package) (with-store store (package-output store package)))

;; Colors
(define fujiWhite     "#DCD7BA")
(define old-white     "#C8C093")
(define sumiInk-0     "#16161D")
(define sumiInk-1b    "#181820")
(define sumiInk-1     "#1F1F28")
(define sumiInk-2     "#2A2A37")
(define sumiInk-3     "#363646")
(define sumiInk-4     "#54546D")
(define waveBlue-1    "#223249")
(define waveBlue-2    "#2D4F67")
(define waveAqua1     "#6A9589")
(define waveAqua2     "#7AA89F")
(define winterGreen   "#2B3328")
(define winterYellow  "#49443C")
(define winterRed     "#43242B")
(define winterBlue    "#252535")
(define autumnGreen   "#76946A")
(define autumnRed     "#C34043")
(define autumnYellow  "#DCA561")
(define samuraiRed    "#E82424")
(define roninYellow   "#FF9E3B")
(define dragonBlue    "#658594")
(define fujiGray      "#727169")
(define springViolet1 "#938AA9")
(define oniViolet     "#957FB8")
(define crystalBlue   "#7E9CD8")
(define springViolet2 "#9CABCA")
(define springBlue    "#7FB4CA")
(define lightBlue     "#A3D4D5")
(define springGreen   "#98BB6C")
(define boatYellow1   "#938056")
(define boatYellow2   "#C0A36E")
(define carpYellow    "#E6C384")
(define sakuraPink    "#D27E99")
(define waveRed       "#E46876")
(define peachRed      "#FF5D62")
(define surimiOrange  "#FFA066")
(define katanaGray    "#717C7C")
(define comet         "#54536D")

(define font-family "Victor Mono")

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

(define sway-font (string-append font-family " Medium 12px"))

(define sway-options
  `(("floating_modifier" ,sway-mod "normal")
                       
    ;; Output
    ("output * bg" ,sumiInk-0 "solid_color")

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
    ("client.focused" ,crystalBlue ,crystalBlue ,sumiInk-0 ,springBlue ,crystalBlue)
    ("client.focused_inactive" ,sumiInk-1b ,sumiInk-1b ,fujiWhite ,springBlue ,sumiInk-1b)
    ("client.unfocused" ,sumiInk-1b ,sumiInk-1b ,fujiWhite ,springBlue ,sumiInk-1b)
    ("client.urgent" ,peachRed ,peachRed ,sumiInk-0 ,springBlue ,peachRed)
                       
    ;; Bar
    ("bar position top")
    ("bar font" ,sway-font)
    ("bar status_command while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done")
    ("bar colors background" ,sumiInk-0)
    ("bar colors statusline" ,fujiWhite)
    ("bar colors separator" ,sumiInk-0)
    ("bar colors focused_workspace" ,crystalBlue ,crystalBlue ,sumiInk-0)
    ("bar colors active_workspace" ,sumiInk-0 ,sumiInk-0 ,fujiWhite)
    ("bar colors inactive_workspace" ,sumiInk-0 ,sumiInk-0 ,fujiWhite)
    ("bar colors urgent_workspace" ,peachRed ,peachRed ,sumiInk-0)))

(define sway-keybinds
  (append '(;; Applications
	    ("Return" . "exec emacs --eval '(eshell)'")
	    ("q" . "exec qutebrowser --qt-flag disable-seccomp-filter-sandbox")
	    ("e" . "exec emacsclient -c")
	    ("Alt+e" . "exec kill $(ps -A | grep 'emacs-' | awk '{print $1;}') && emacs --bg-daemon")
	    ("x" . "exec bemenu-run")
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
    ("fonts.default_family" . ,font-family)
    ("fonts.web.family.fixed" . ,font-family)
    ("colors.completion.category.bg" . ,sumiInk-1b)
    ("colors.completion.category.fg" . ,fujiWhite)
    ("colors.completion.category.border.top" . ,sumiInk-1b)
    ("colors.completion.category.border.bottom" . ,sumiInk-1b)
    ("colors.completion.item.selected.bg" . ,crystalBlue)
    ("colors.completion.item.selected.fg" . ,sumiInk-0)
    ("colors.completion.item.selected.border.top" . ,crystalBlue)
    ("colors.completion.item.selected.border.bottom" . ,crystalBlue)
    ("colors.completion.match.fg" . ,fujiWhite)
    ("colors.completion.even.bg" . ,sumiInk-1b)
    ("colors.completion.odd.bg" . ,sumiInk-1b)
    ("colors.completion.fg" . ,fujiWhite)
    ("colors.completion.scrollbar.bg" . ,sumiInk-1b)
    ("colors.completion.scrollbar.fg" . ,fujiWhite)
    ("colors.contextmenu.disabled.bg" . ,sumiInk-1b)
    ("colors.contextmenu.disabled.fg" . ,peachRed)
    ("colors.contextmenu.menu.bg" . ,sumiInk-1b)
    ("colors.contextmenu.menu.fg" . ,fujiWhite)
    ("colors.contextmenu.selected.bg" . ,crystalBlue)
    ("colors.contextmenu.selected.fg" . ,fujiWhite)
    ("colors.downloads.bar.bg" . ,sumiInk-1b)
    ("colors.downloads.error.bg" . ,peachRed)
    ("colors.downloads.error.fg" . ,sumiInk-1b)
    ("colors.downloads.start.bg" . ,sumiInk-1b)
    ("colors.downloads.start.fg" . ,fujiWhite)
    ("colors.downloads.stop.bg" . ,sumiInk-1b)
    ("colors.downloads.stop.fg" . ,fujiWhite)
    ("colors.downloads.system.bg" . "rgb")
    ("colors.downloads.system.fg" . "rgb")
    ("colors.hints.bg" . ,surimiOrange)
    ("colors.hints.fg" . ,sumiInk-1b)
    ("colors.hints.match.fg" . ,sumiInk-2)
    ("colors.keyhint.bg" . ,surimiOrange)
    ("colors.keyhint.fg" . ,sumiInk-1b)
    ("colors.keyhint.suffix.fg" . ,sumiInk-1b)
    ("colors.messages.error.bg" . ,peachRed)
    ("colors.messages.error.border" . ,sumiInk-1b)
    ("colors.messages.error.fg" . ,sumiInk-1b)
    ("colors.messages.info.bg" . ,crystalBlue)
    ("colors.messages.info.border" . ,sumiInk-1b)
    ("colors.messages.info.fg" . ,sumiInk-1b)
    ("colors.messages.warning.bg" . ,surimiOrange)
    ("colors.messages.warning.border" . ,sumiInk-1b)
    ("colors.messages.warning.fg" . ,sumiInk-1b)
    ("colors.prompts.bg" . ,springGreen)
    ("colors.prompts.border" . ,sumiInk-1b)
    ("colors.prompts.fg" . ,sumiInk-1b)
    ("colors.prompts.selected.fg" . ,sumiInk-0)
    ("colors.prompts.selected.bg" . ,crystalBlue)
    ("colors.statusbar.caret.bg" . ,crystalBlue)
    ("colors.statusbar.caret.fg" . ,sumiInk-0)
    ("colors.statusbar.caret.selection.bg" . ,crystalBlue)
    ("colors.statusbar.caret.selection.fg" . ,sumiInk-0)
    ("colors.statusbar.command.bg" . ,sumiInk-1b)
    ("colors.statusbar.command.fg" . ,fujiWhite)
    ("colors.statusbar.command.private.bg" . ,sumiInk-1b)
    ("colors.statusbar.command.private.fg" . ,fujiWhite)
    ("colors.statusbar.insert.bg" . ,sumiInk-1b)
    ("colors.statusbar.insert.fg" . ,fujiWhite)
    ("colors.statusbar.normal.bg" . ,sumiInk-1b)
    ("colors.statusbar.normal.fg" . ,fujiWhite)
    ("colors.statusbar.passthrough.bg" . ,sumiInk-1b)
    ("colors.statusbar.passthrough.fg" . ,fujiWhite)
    ("colors.statusbar.private.bg" . ,sumiInk-1b)
    ("colors.statusbar.private.fg" . ,fujiWhite)
    ("colors.statusbar.progress.bg" . ,fujiWhite)
    ("colors.statusbar.url.error.fg" . ,peachRed)
    ("colors.statusbar.url.fg" . ,fujiWhite)
    ("colors.statusbar.url.hover.fg" . ,fujiWhite)
    ("colors.statusbar.url.success.http.fg" . ,peachRed)
    ("colors.statusbar.url.success.https.fg" . ,fujiWhite)
    ("colors.statusbar.url.warn.fg" . ,surimiOrange)
    ("colors.tabs.bar.bg" . ,crystalBlue)
    ("colors.tabs.even.bg" . ,sumiInk-1b)
    ("colors.tabs.even.fg" . ,fujiWhite)
    ("colors.tabs.indicator.error" . ,peachRed)
    ("colors.tabs.indicator.start" . ,crystalBlue)
    ("colors.tabs.indicator.stop" . ,springGreen)
    ("colors.tabs.indicator.system" . "rgb")
    ("colors.tabs.odd.bg" . ,sumiInk-1b)
    ("colors.tabs.odd.fg" . ,fujiWhite)
    ("colors.tabs.pinned.even.bg" . ,sumiInk-1b)
    ("colors.tabs.pinned.even.fg" . ,fujiWhite)
    ("colors.tabs.pinned.odd.bg" . ,sumiInk-1b)
    ("colors.tabs.pinned.odd.fg" . ,fujiWhite)
    ("colors.tabs.pinned.selected.even.bg" . ,crystalBlue)
    ("colors.tabs.pinned.selected.even.fg" . ,sumiInk-0)
    ("colors.tabs.pinned.selected.odd.bg" . ,crystalBlue)
    ("colors.tabs.pinned.selected.odd.fg" . ,sumiInk-0)
    ("colors.tabs.selected.even.bg" . ,crystalBlue)
    ("colors.tabs.selected.even.fg" . ,sumiInk-0)
    ("colors.tabs.selected.odd.bg" . ,crystalBlue)
    ("colors.tabs.selected.odd.fg" . ,sumiInk-0)
    ("colors.webpage.bg" . ,sumiInk-1b)
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
