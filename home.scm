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
	     (gnu packages python-crypto)
	     (gnu packages python-build)
	     (gnu packages python-web)
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
	     (gnu packages xml)
	     (gnu packages haskell-xyz)
	     (gnu packages check)
	     (gnu packages aspell)
	     (gnu packages gcc)
	     (gnu packages cross-base)
	     (gnu packages flashing-tools)
	     (gnu packages rsync)
	     (guix gexp)
	     (guix store)
	     (guix packages)
	     (guix git-download)
	     (guix build-system python)
	     (guix licenses)
	     (ice-9 textual-ports)
	     (ice-9 string-fun)
	     (ice-9 eval-string)
	     (system base compile))

;; Utilities

(define (read-file filename) (call-with-input-file filename get-string-all))

(define (store-path package) (with-store store (package-output store package)))

(define (equals-line a)
  (format #f "~a=~a\n" (car a) (cadr a)))

;; Shared data

(define shared-data (eval-string (read-file "./shared.el") #:lang 'elisp))

(define (d key)
  (cdr (assoc key shared-data)))

;; Bash

(define shell-aliases
  '(
    ;; ls
    ("ls" "ls --color")
    ("l" "ls -la")

    ;; git
    ("ga" "git add -A")
    ("gc" "git commit -m")
    ("gp" "git push origin")
    ("gg" "git log --graph --pretty=oneline --abbrev-commit")
    ("gl" "git log --graph --pretty=short")
    ("gac" "ga && gc")
    ("gf" "git fetch")
    ("gs" "git status")
    ("gd" "git diff")

    ;; mpv
    ("mpva" "mpv --no-video")
    ("mpvterm" "DISPLAY= mpv -vo caca")

    ;; guix
    ("ghr" "guix home reconfigure")
    ("gsr" "guix system reconfigure")
    ("ghdg" "guix home delete-generations")
    ("gsdg" "guix system delete-generations")
    ("ggc" "guix gc")

    ;; Other
    ("rm" "trash")))

(define bashrc (string-append
		(read-file "./bash/vterm.sh")
		"set -o vi\n" ; VI mode
		(apply string-append (map (lambda (a) (format #f "alias ~a='~a'\n" (car a) (string-replace-substring (cadr a) "'" "'\\''"))) shell-aliases))))

;; Bemenu
(define bemenu-options
  (apply string-append
	 (map (lambda (x)
		(string-append "--" (car x) " '" (cadr x) "' "))
	      `(("fn" ,(string-append (d 'font-family) " 13"))
		("tb" ,(d 'dark-bg))
		("tf" ,(d 'accent))
		("fb" ,(d 'dark-bg))
		("ff" ,(d 'dark-fg))
		("nb" ,(d 'dark-bg))
		("nf" ,(d 'dark-fg))
		("hb" ,(d 'dark-bg))
		("hf" ,(d 'accent))
		("sb" ,(d 'dark-bg))
		("sf" ,(d 'accent))
		("fbb" ,(d 'dark-bg))
		("fbf" ,(d 'dark-fg))
		("ab" ,(d 'dark-bg))
		("af" ,(d 'dark-fg))
		("ab" ,(d 'dark-bg))
		("af" ,(d 'dark-fg))
		("scb" ,(d 'dark-bg))
		("scf" ,(d 'dark-fg))
		("bdr" ,(d 'dark-bg))))))

;; Sway

(define sway-mod "Mod4")

(define sway-extra-config "
exec emacs --bg-daemon
exec swayidle -w \\
    timeout 300 'swaylock -f -c 000000' \\
    timeout 600 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' \\
    before-sleep 'swaylock -f -c 000000'
exec wireplumber
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
	    ("q" "exec qutebrowser --qt-flag disable-seccomp-filter-sandbox")
	    ("e" "exec emacsclient -c")
	    ("Alt+e" "exec kill $(ps -A | grep 'emacs-' | awk '{print $1;}') && emacs --bg-daemon")
	    ("x" ,(string-append  "exec bemenu-run " bemenu-options))
	    ("Shift+x" ,(string-append "exec flatpak run $(flatpak list --columns=application | bemenu " bemenu-options ")"))
	    ("Alt+s" "exec grimshot save screen ~/Pictures/screenshots/$(date +'%Y%m%d%I%M%S').png")
	    ("Shift+s" "exec grimshot save area ~/Pictures/screenshots/$(date +'%Y%m%d%I%M%S').png")

	    ;; Windows
	    ("h" "focus left")
	    ("j" "focus down")
	    ("k" "focus up")
	    ("l" "focus right")
	    ("Shift+h" "move left")
	    ("Shift+j" "move down")
	    ("Shift+k" "move up")
	    ("Shift+l" "move right")

	    ;; Layout
	    ("b" "splith")
	    ("v" "splitv")
	    ("w" "layout tabbed")
	    ("s" "layout toggle split")
	    ("f" "fullscreen")
	    ("Shift+space" "floating toggle")
	    ("space" "focus mode_toggle")
	    ("r" "mode resize")

	    ;; Other
	    ("Shift+q" "kill")
	    ("Shift+c" "reload")
	    ("Shift+e" "exec swaynag -t warning -m 'Exit?' -b 'Yes' 'swaymsg exit'"))
	  ;; Workspaces
	  (apply append (map (lambda (n) (list (list (format #f "~a" n) (format #f "workspace number ~a" n))
					       (list (format #f "Shift+~a" n) (format #f "move container to workspace number ~a" n))))
			     (iota 9 1)))))

(define (sway-option->string o)
  (apply string-append
	 (map (lambda (a)
		(string-append a " ")) o)))

(define sway-config
  (string-append (apply string-append (map (lambda (a) (format #f "bindsym ~a+~a ~a\n" sway-mod (car a) (cadr a))) sway-keybinds))
		 (apply string-append (map (lambda (a) (format #f "~a\n" (sway-option->string a))) sway-options))
		 sway-extra-config))

;; Git

(define git-config "
[user]
  email = carllegrone@protonmail.com
  name = nph278
[core]
  excludesfile = ~/.global.gitignore   
[http]
  sslVerify = false
")

;; Minidlna

(define minidlna-config
  (apply string-append
	 (map (lambda (x) (string-append (car x) "=" (cadr x) "\n"))
	      '(("media_dir" "A,/home/carl/Music")
		("db_dir" "/home/carl/.config/minidlna/db")
		("log_dir" "/home/carl/.config/minidlna/log")
		("friendly_name" "Vargomax V. Vargomax's Insane Collection")
		("inotify" "yes")
		("presentation_url" "http://192.168.1.5")))))

;; Abcde

(define abcde-config
  (apply string-append
	 (map equals-line
	      '(("OUTPUTTYPE" "flac")))))

;; Mpv

(define mpv-config
  (apply string-append
	 (map equals-line
	      '(("osc" "no")
		("volume" "50")
		("background" "'#00000000'")
		("alpha" "yes")))))

(define mpv-input-config
  (apply string-append
	 (map (lambda (a) (string-append (string-join a " ") "\n"))
	      '(("h" "seek" "-2")
		("l" "seek" "2")
		("j" "add" "volume" "-2")
		("k" "add" "volume" "2")
		("J" "add" "speed" "-0.05")
		("K" "add" "speed" "0.05")))))

;; Qutebrwoser

(define qutebrowser-options
  `(("url.default_page" "about:blank")
    ("fonts.default_family" font-family)
    ("fonts.web.family.fixed" font-family)
    ("colors.completion.category.bg" dark-bg)
    ("colors.completion.category.fg" dark-fg)
    ("colors.completion.category.border.top" dark-bg)
    ("colors.completion.category.border.bottom" dark-bg)
    ("colors.completion.item.selected.bg" accent)
    ("colors.completion.item.selected.fg" light-fg)
    ("colors.completion.item.selected.match.fg" light-fg)
    ("colors.completion.item.selected.border.top" accent)
    ("colors.completion.item.selected.border.bottom" accent)
    ("colors.completion.match.fg" dark-fg)
    ("colors.completion.even.bg" dark-bg)
    ("colors.completion.odd.bg" dark-bg)
    ("colors.completion.fg" dark-fg)
    ("colors.completion.scrollbar.bg" dark-bg)
    ("colors.completion.scrollbar.fg" dark-fg)
    ("colors.contextmenu.disabled.bg" dark-bg)
    ("colors.contextmenu.disabled.fg" red)
    ("colors.contextmenu.menu.bg" dark-bg)
    ("colors.contextmenu.menu.fg" dark-fg)
    ("colors.contextmenu.selected.bg" accent)
    ("colors.contextmenu.selected.fg" light-fg)
    ("colors.downloads.bar.bg" dark-bg)
    ("colors.downloads.error.bg" red)
    ("colors.downloads.error.fg" light-fg)
    ("colors.downloads.start.bg" dark-bg)
    ("colors.downloads.start.fg" dark-fg)
    ("colors.downloads.stop.bg" green)
    ("colors.downloads.stop.fg" light-fg)
    ("colors.downloads.system.bg" "hsl")
    ("colors.downloads.system.fg" "hsl")
    ("colors.hints.bg" yellow)
    ("colors.hints.fg" light-fg)
    ("colors.hints.match.fg" light-fg)
    ("colors.keyhint.bg" yellow)
    ("colors.keyhint.fg" light-fg)
    ("colors.keyhint.suffix.fg" light-fg)
    ("colors.messages.error.bg" red)
    ("colors.messages.error.border" red)
    ("colors.messages.error.fg" light-fg)
    ("colors.messages.info.bg" accent)
    ("colors.messages.info.border" accent)
    ("colors.messages.info.fg" light-fg)
    ("colors.messages.warning.bg" yellow)
    ("colors.messages.warning.border" yellow)
    ("colors.messages.warning.fg" light-fg)
    ("colors.prompts.bg" accent)
    ("colors.prompts.border" accent)
    ("colors.prompts.fg" light-fg)
    ("colors.prompts.selected.fg" light-fg)
    ("colors.prompts.selected.bg" accent)
    ("colors.statusbar.caret.bg" accent)
    ("colors.statusbar.caret.fg" light-fg)
    ("colors.statusbar.caret.selection.bg" accent)
    ("colors.statusbar.caret.selection.fg" light-fg)
    ("colors.statusbar.command.bg" dark-bg)
    ("colors.statusbar.command.fg" dark-fg)
    ("colors.statusbar.command.private.bg" dark-bg)
    ("colors.statusbar.command.private.fg" dark-fg)
    ("colors.statusbar.insert.bg" dark-bg)
    ("colors.statusbar.insert.fg" dark-fg)
    ("colors.statusbar.normal.bg" dark-bg)
    ("colors.statusbar.normal.fg" dark-fg)
    ("colors.statusbar.passthrough.bg" dark-bg)
    ("colors.statusbar.passthrough.fg" dark-fg)
    ("colors.statusbar.private.bg" dark-bg)
    ("colors.statusbar.private.fg" dark-fg)
    ("colors.statusbar.progress.bg" dark-fg)
    ("colors.statusbar.url.error.fg" red)
    ("colors.statusbar.url.fg" dark-fg)
    ("colors.statusbar.url.hover.fg" dark-fg)
    ("colors.statusbar.url.success.http.fg" red)
    ("colors.statusbar.url.success.https.fg" dark-fg)
    ("colors.statusbar.url.warn.fg" yellow)
    ("colors.tabs.bar.bg" dark-bg)
    ("colors.tabs.even.bg" dark-bg)
    ("colors.tabs.even.fg" dark-fg)
    ("colors.tabs.indicator.error" red)
    ("colors.tabs.indicator.start" accent)
    ("colors.tabs.indicator.stop" accent)
    ("colors.tabs.indicator.system" "none")
    ("colors.tabs.odd.bg" dark-bg)
    ("colors.tabs.odd.fg" dark-fg)
    ("colors.tabs.pinned.even.bg" dark-bg)
    ("colors.tabs.pinned.even.fg" dark-fg)
    ("colors.tabs.pinned.odd.bg" dark-bg)
    ("colors.tabs.pinned.odd.fg" dark-fg)
    ("colors.tabs.pinned.selected.even.bg" accent)
    ("colors.tabs.pinned.selected.even.fg" light-fg)
    ("colors.tabs.pinned.selected.odd.bg" accent)
    ("colors.tabs.pinned.selected.odd.fg" light-fg)
    ("colors.tabs.selected.even.bg" accent)
    ("colors.tabs.selected.even.fg" light-fg)
    ("colors.tabs.selected.odd.bg" accent)
    ("colors.tabs.selected.odd.fg" light-fg)
    ("colors.webpage.preferred_color_scheme" "dark")
    ("content.blocking.enabled" #t)
    ("content.blocking.adblock.lists"
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
    ("content.blocking.hosts.lists" ("https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"))
    ("content.blocking.method" "auto")
    ("content.user_stylesheets" ("~/.config/web.css"))
    ("auto_save.session" #t)))

(define (expr->python e)
  (cond 
   [(symbol? e) (string-append "\"" (d e) "\"")]
   [(string? e) (string-append "\"" e "\"")]
   [(boolean? e) (if e "True" "False")]
   [(number? e) (number->string e)]
   [(list? e) (apply string-append `("[" ,@(map (lambda (x) (string-append (expr->python x) ",")) e) "]"))]))

(define (qutebrowser-option->string o)
  (string-append "c." (car o) " = " (expr->python (cadr o)) "\n"))

(define qutebrowser-config
  (string-append (apply string-append
			(map qutebrowser-option->string qutebrowser-options))
		 "config.load_autoconfig(False)\n"))

(define web-stylesheet
  "")

;; Beets

(define beets-config
  "directory: ~/Music
library: ~/.musiclibrary.db")

;; Configuration

(define config-files
  `( ;; mpv
    (".config/mpv/mpv.conf" ,mpv-config)
    (".config/mpv/input.conf" ,mpv-input-config)

    ;; Emacs
    (".emacs.d/init.el" ,(read-file "emacs/init.el"))
    (".emacs.d/themes/custom-theme.el" ,(read-file "emacs/theme.el"))
    (".emacs.d/shared.el" ,(read-file "shared.el"))

    ;; Sway
    (".config/sway/config" ,sway-config)

    ;; Bash
    (".bashrc" ,bashrc)

    ;; Git
    (".gitconfig" ,git-config)
    (".global.gitignore" ,(read-file ".global.gitignore"))

    ;; Minidlna
    (".config/minidlna/minidlna.conf" ,minidlna-config)

    ;; ABCDE
    (".abcde.conf" ,abcde-config)

    ;; Qutebrowser
    (".config/qutebrowser/config.py" ,qutebrowser-config)

    ;; CSS
    (".config/web.css" ,web-stylesheet)

    ;; Beets
    (".config/beets/config.yaml" ,beets-config)))

;; Custom packages

(define-public python-dominate
  (package
    (name "python-dominate")
    (version "2.9.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/Knio/dominate")
               (commit version)))
        (file-name (git-file-name name version))
        (sha256
         (base32
          "1pkdf94r4slvk81px2347z538zfbmi0p4xbq2ijjpfkv77q9jlg6"))))
    (build-system python-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
	 (add-before 'build 'copy-setuppy
           (lambda _
             (copy-file "setup/setup.py" "setup.py")))
	 (replace 'check
           (lambda _
	     (invoke "make" "test"))))))
    (native-inputs (list python-setuptools python-pytest))
    (home-page "https://github.com/Knio/dominate")
    (synopsis "A Python library for creating and manipulating HTML documents using an elegant DOM API.")
    (description "Dominate is a Python library for creating and manipulating
 HTML documents using an elegant DOM API. It allows you to write HTML pages 
in pure Python very concisely, which eliminate the need to learn another 
template language, and to take advantage of the more powerful features of Python.")
    (license lgpl3)))

(define-public pass-import
  (package
    (name "pass-import")
    (version "3.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/roddhjav/pass-import")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "031rcl67vqraq2rfwiaiydjrzr8rl8a1z89mdhwm2s30i9cn1j1l"))))
    (build-system python-build-system)
    (arguments
     '(#:tests?
       #f ; Some tests require packages which will not be added
       #:phases
       (modify-phases %standard-phases
	 (add-before 'build 'patch-setup-cfg
	   (lambda _
	     (substitute* "setup.cfg"
	       (("attr: pass_import.__version__") (version)))))
	 (add-before 'install 'manpage
           (lambda _
             (invoke "make" "docs")))
	 (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (setenv "DESTDIR" (assoc-ref outputs "out"))
             (invoke "make" "install"))))))
    (native-inputs
     (list python-setuptools
	   python-dominate
	   pandoc))
    (propagated-inputs
     (list python-pykeepass
	   python-defusedxml
	   python-secretstorage
	   python-cryptography
	   python-requests
	   python-zxcvbn
	   python-pyyaml
	   python-pyaml))
    (home-page "https://github.com/roddhjav/pass-import")
    (synopsis "A pass extension for importing data from most existing password managers")
    (description "Pass import is a password store extension allowing you to 
import your password database to a password store repository conveniently. 
It natively supports import from 62 different password managers. 
More manager support can easily be added.")
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
	    ispell
            rsync

	    ;; Sway
	    sway
	    swaylock
	    grimshot
	    wl-clipboard
	    
	    ;; pass
	    password-store
	    pass-import

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
            wireplumber

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

            ;; C
            gcc
            (cross-gcc-toolchain "avr")

	    ;; Emacs
	    emacs
	    emacs-evil
	    emacs-geiser
	    emacs-geiser-guile
	    emacs-racket-mode
	    emacs-paredit
	    emacs-org
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
	    emacs-pass
	    emacs-magit

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
	    kicad-templates

            ;; AVR
            avrdude))
 (services
  (list
   (simple-service 'configuration-files
		   home-files-service-type
		   (append (map (lambda (x)
				  (define filename (car x))
				  (define contents (cadr x))
				  (list filename (plain-file "config-file" contents)))
				config-files)
			   `((".config/blank.png" ,(local-file "images/blank.png"))))))))

