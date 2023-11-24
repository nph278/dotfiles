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
	     (gnu packages engineering)
	     (gnu packages freedesktop)
	     (guix gexp)
	     (guix store)
	     (guix packages)
	     (guix git-download)
	     (guix build-system emacs)
	     (guix licenses)
	     (ice-9 textual-ports)
	     (ice-9 string-fun)
	     (ice-9 eval-string)
	     (system base compile))

(define (read-file filename) (call-with-input-file filename get-string-all))
(define (store-path package) (with-store store (package-output store package)))

(define shared-data (eval-string (read-file "./shared.el") #:lang 'elisp))

;; Shared data
(define (d key)
  (cdr (assoc key shared-data)))

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

    ;; Other
    ("rm" . "trash")))

(define bashrc (string-append
		(read-file "./bash/vterm.sh")
		"set -o vi\n" ; VI mode
		(apply string-append (map (lambda (a) (format #f "alias ~a='~a'\n" (car a) (string-replace-substring (cdr a) "'" "'\\''"))) shell-aliases))))

(define bemenu-options
  (apply string-append
	 (map (lambda (x)
		(string-append "--" (car x) " '" (cdr x) "' "))
	      `(("fn" . ,(string-append (d 'font-family) " 13"))
		("tb" . ,(d 'dark-bg))
		("tf" . ,(d 'accent))
		("fb" . ,(d 'dark-bg))
		("ff" . ,(d 'dark-fg))
		("nb" . ,(d 'dark-bg))
		("nf" . ,(d 'dark-fg))
		("hb" . ,(d 'dark-bg))
		("hf" . ,(d 'accent))
		("sb" . ,(d 'dark-bg))
		("sf" . ,(d 'accent))
		("fbb" . ,(d 'dark-bg))
		("fbf" . ,(d 'dark-fg))
		("ab" . ,(d 'dark-bg))
		("af" . ,(d 'dark-fg))
		("ab" . ,(d 'dark-bg))
		("af" . ,(d 'dark-fg))
		("scb" . ,(d 'dark-bg))
		("scf" . ,(d 'dark-fg))
		("bdr" . ,(d 'dark-bg))))))

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
    ("output * bg" ,(d 'dark-bg) "solid_color")

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
    ("client.focused" ,(d 'accent) ,(d 'accent) ,(d 'light-fg) ,(d 'green) ,(d 'accent))
    ("client.focused_inactive" ,(d 'dark-bg) ,(d 'dark-bg) ,(d 'dark-fg) ,(d 'green) ,(d 'dark-bg))
    ("client.unfocused" ,(d 'dark-bg) ,(d 'dark-bg) ,(d 'dark-fg) ,(d 'green) ,(d 'dark-bg))
    ("client.urgent" ,(d 'red) ,(d 'red) ,(d 'light-fg) ,(d 'green) ,(d 'red))
                       
    ;; Bar
    ("bar position top")
    ("bar font" ,sway-font)
    ("bar status_command while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done")
    ("bar colors background" ,(d 'dark-bg))
    ("bar colors statusline" ,(d 'dark-fg))
    ("bar colors separator" ,(d 'dark-bg))
    ("bar colors focused_workspace" ,(d 'accent) ,(d 'accent) ,(d 'light-fg))
    ("bar colors active_workspace" ,(d 'dark-bg) ,(d 'dark-bg) ,(d 'dark-fg))
    ("bar colors inactive_workspace" ,(d 'dark-bg) ,(d 'dark-bg) ,(d 'dark-fg))
    ("bar colors urgent_workspace" ,(d 'red) ,(d 'red) ,(d 'light-fg))))

(define sway-keybinds
  (append `(;; Applications
	    ("Return" . "exec emacs --eval '(eshell)'")
	    ("q" . "exec qutebrowser --qt-flag disable-seccomp-filter-sandbox")
	    ("e" . "exec emacsclient -c")
	    ("Alt+e" . "exec kill $(ps -A | grep 'emacs-' | awk '{print $1;}') && emacs --bg-daemon")
	    ("x" . ,(string-append  "exec bemenu-run " bemenu-options))
	    ("Shift+x" . ,(string-append "exec flatpak run $(flatpak list --columns=application | bemenu " bemenu-options ")"))
	    ("Alt+s" . "exec grimshot save scree20230711095930.pngn ~/Pictures/screenshots/$(date +'%Y%m%d%I%M%S').png")
	    ("Shift+s" . "exec grimshot save area ~/Pictures/screenshots/$(date +'%Y%m%d%I%M%S').png")

	    ;; Music
	    ("m" . ,(string-append "exec mpv --cover-art-files=/home/carl/.config/blank.png \"$(beet ls -f '$path' \"$(beet ls -f '$title' | bemenu -i " bemenu-options ")\")\""))
	    ("Shift+m" . ,(string-append "exec mpv --cover-art-files=/home/carl/.config/blank.png \"$(beet ls -a -f '$path' \"$(beet ls -a -f '$album' | bemenu -i " bemenu-options ")\")\""))
	    ("Alt+m" . "exec mpv --cover-art-files=/home/carl/.config/blank.png --shuffle ~/Music")

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
[http]
  sslVerify = false
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
		("volume" . "50")
		("background" . "'#00000000'")
		("alpha" . "yes")))))

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
    ("colors.completion.category.bg" . ,(d 'dark-bg))
    ("colors.completion.category.fg" . ,(d 'dark-fg))
    ("colors.completion.category.border.top" . ,(d 'dark-bg))
    ("colors.completion.category.border.bottom" . ,(d 'dark-bg))
    ("colors.completion.item.selected.bg" . ,(d 'accent))
    ("colors.completion.item.selected.fg" . ,(d 'light-fg))
    ("colors.completion.item.selected.match.fg" . ,(d 'light-fg))
    ("colors.completion.item.selected.border.top" . ,(d 'accent))
    ("colors.completion.item.selected.border.bottom" . ,(d 'accent))
    ("colors.completion.match.fg" . ,(d 'dark-fg))
    ("colors.completion.even.bg" . ,(d 'dark-bg))
    ("colors.completion.odd.bg" . ,(d 'dark-bg))
    ("colors.completion.fg" . ,(d 'dark-fg))
    ("colors.completion.scrollbar.bg" . ,(d 'dark-bg))
    ("colors.completion.scrollbar.fg" . ,(d 'dark-fg))
    ("colors.contextmenu.disabled.bg" . ,(d 'dark-bg))
    ("colors.contextmenu.disabled.fg" . ,(d 'red))
    ("colors.contextmenu.menu.bg" . ,(d 'dark-bg))
    ("colors.contextmenu.menu.fg" . ,(d 'dark-fg))
    ("colors.contextmenu.selected.bg" . ,(d 'accent))
    ("colors.contextmenu.selected.fg" . ,(d 'light-fg))
    ("colors.downloads.bar.bg" . ,(d 'dark-bg))
    ("colors.downloads.error.bg" . ,(d 'red))
    ("colors.downloads.error.fg" . ,(d 'light-fg))
    ("colors.downloads.start.bg" . ,(d 'dark-bg))
    ("colors.downloads.start.fg" . ,(d 'dark-fg))
    ("colors.downloads.stop.bg" . ,(d 'green))
    ("colors.downloads.stop.fg" . ,(d 'light-fg))
    ("colors.downloads.system.bg" . "hsl")
    ("colors.downloads.system.fg" . "hsl")
    ("colors.hints.bg" . ,(d 'yellow))
    ("colors.hints.fg" . ,(d 'light-fg))
    ("colors.hints.match.fg" . ,(d 'light-fg))
    ("colors.keyhint.bg" . ,(d 'yellow))
    ("colors.keyhint.fg" . ,(d 'light-fg))
    ("colors.keyhint.suffix.fg" . ,(d 'light-fg))
    ("colors.messages.error.bg" . ,(d 'red))
    ("colors.messages.error.border" . ,(d 'red))
    ("colors.messages.error.fg" . ,(d 'light-fg))
    ("colors.messages.info.bg" . ,(d 'accent))
    ("colors.messages.info.border" . ,(d 'accent))
    ("colors.messages.info.fg" . ,(d 'light-fg))
    ("colors.messages.warning.bg" . ,(d 'yellow))
    ("colors.messages.warning.border" . ,(d 'yellow))
    ("colors.messages.warning.fg" . ,(d 'light-fg))
    ("colors.prompts.bg" . ,(d 'accent))
    ("colors.prompts.border" . ,(d 'accent))
    ("colors.prompts.fg" . ,(d 'light-fg))
    ("colors.prompts.selected.fg" . ,(d 'light-fg))
    ("colors.prompts.selected.bg" . ,(d 'accent))
    ("colors.statusbar.caret.bg" . ,(d 'accent))
    ("colors.statusbar.caret.fg" . ,(d 'light-fg))
    ("colors.statusbar.caret.selection.bg" . ,(d 'accent))
    ("colors.statusbar.caret.selection.fg" . ,(d 'light-fg))
    ("colors.statusbar.command.bg" . ,(d 'dark-bg))
    ("colors.statusbar.command.fg" . ,(d 'dark-fg))
    ("colors.statusbar.command.private.bg" . ,(d 'dark-bg))
    ("colors.statusbar.command.private.fg" . ,(d 'dark-fg))
    ("colors.statusbar.insert.bg" . ,(d 'dark-bg))
    ("colors.statusbar.insert.fg" . ,(d 'dark-fg))
    ("colors.statusbar.normal.bg" . ,(d 'dark-bg))
    ("colors.statusbar.normal.fg" . ,(d 'dark-fg))
    ("colors.statusbar.passthrough.bg" . ,(d 'dark-bg))
    ("colors.statusbar.passthrough.fg" . ,(d 'dark-fg))
    ("colors.statusbar.private.bg" . ,(d 'dark-bg))
    ("colors.statusbar.private.fg" . ,(d 'dark-fg))
    ("colors.statusbar.progress.bg" . ,(d 'dark-fg))
    ("colors.statusbar.url.error.fg" . ,(d 'red))
    ("colors.statusbar.url.fg" . ,(d 'dark-fg))
    ("colors.statusbar.url.hover.fg" . ,(d 'dark-fg))
    ("colors.statusbar.url.success.http.fg" . ,(d 'red))
    ("colors.statusbar.url.success.https.fg" . ,(d 'dark-fg))
    ("colors.statusbar.url.warn.fg" . ,(d 'yellow))
    ("colors.tabs.bar.bg" . ,(d 'dark-bg))
    ("colors.tabs.even.bg" . ,(d 'dark-bg))
    ("colors.tabs.even.fg" . ,(d 'dark-fg))
    ("colors.tabs.indicator.error" . ,(d 'red))
    ("colors.tabs.indicator.start" . ,(d 'accent))
    ("colors.tabs.indicator.stop" . ,(d 'accent))
    ("colors.tabs.indicator.system" . "none")
    ("colors.tabs.odd.bg" . ,(d 'dark-bg))
    ("colors.tabs.odd.fg" . ,(d 'dark-fg))
    ("colors.tabs.pinned.even.bg" . ,(d 'dark-bg))
    ("colors.tabs.pinned.even.fg" . ,(d 'dark-fg))
    ("colors.tabs.pinned.odd.bg" . ,(d 'dark-bg))
    ("colors.tabs.pinned.odd.fg" . ,(d 'dark-fg))
    ("colors.tabs.pinned.selected.even.bg" . ,(d 'accent))
    ("colors.tabs.pinned.selected.even.fg" . ,(d 'light-fg))
    ("colors.tabs.pinned.selected.odd.bg" . ,(d 'accent))
    ("colors.tabs.pinned.selected.odd.fg" . ,(d 'light-fg))
    ("colors.tabs.selected.even.bg" . ,(d 'accent))
    ("colors.tabs.selected.even.fg" . ,(d 'light-fg))
    ("colors.tabs.selected.odd.bg" . ,(d 'accent))
    ("colors.tabs.selected.odd.fg" . ,(d 'light-fg))
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

(define beets-config
  "directory: ~/Music
library: ~/.musiclibrary.db")

(define config-files
  `( ;; mpv
    (".config/mpv/mpv.conf" . ,mpv-config)
    (".config/mpv/input.conf" . ,mpv-input-config)

    ;; Emacs
    (".emacs.d/init.el" . ,(read-file "emacs/init.el"))
    (".emacs.d/themes/custom-theme.el" . ,(read-file "emacs/theme.el"))
    (".emacs.d/shared.el" . ,(read-file "shared.el"))

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
    (".config/qutebrowser/config.py" . ,qutebrowser-config)

    ;; Beets
    (".config/beets/config.yaml" . ,beets-config)))

(define-public emacs-keepass-mode
  (package
    (name "emacs-keepass-mode")
    (version "0.0.5")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ifosch/keepass-mode")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0wrzbcd070l8yjqxg7mmglc3kfgy420y3wnykky198y83xsv3qy2"))))
    (build-system emacs-build-system)
    (propagated-inputs (list emacs-dash emacs-with-editor emacs-magit))
    (home-page "https://github.com/ifosch/keepass-mode")
    (synopsis "Emacs mode to open KeePass DB")
    (description
     "This provides an Emacs major mode to open KeePass DB files, navigate 
through them, show their entries, and copy the passwords to the clipboard. ")
    (license gpl3)))

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
	    xdg-utils

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

	    ;; Images
	    gimp

	    ;; TeX
	    texlive-tex
	    texlive-latex

	    ;; Development
	    git
	    openssh

	    ;; Rust
	    rust
	    (list rust "cargo")
	    (list rust "tools")

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
	    emacs-elfeed
	    emacs-rainbow-mode
	    emacs-keepass-mode

	    ;; Containers
	    ;; podman
	    ;; iptables

	    ;; Fonts
	    font-google-noto
	    font-google-noto-emoji
	    font-google-noto-sans-cjk
	    font-victor-mono

	    ;; Libreoffice
	    libreoffice

	    ;; kicad
	    kicad
	    kicad-symbols
	    kicad-footprints
	    kicad-templates))
 (services
  (list
   (simple-service 'configuration-files
		   home-files-service-type
		   (append (map (lambda (x)
				  (define filename (car x))
				  (define contents (cdr x))
				  (list filename (plain-file "config-file" contents)))
				config-files)
			   `((".config/blank.png" ,(local-file "images/blank.png"))))))))
