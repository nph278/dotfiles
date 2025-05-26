;; Temporarily reduce garbage collection during startup
(defun reset-gc-cons-threshold ()
  (setq gc-cons-threshold (car (get 'gc-cons-threshold 'standard-value))))
(setq gc-cons-threshold (* 64 1024 1024))
(add-hook 'after-init-hook #'reset-gc-cons-threshold)

;; Temporarily disable the file name handler
(setq default-file-name-handler-alist file-name-handler-alist
      file-name-handler-alist nil)
(defun reset-file-name-handler-alist ()
  (setq file-name-handler-alist
	(append default-file-name-handler-alist
		file-name-handler-alist))
  (cl-delete-duplicates file-name-handler-alist :test 'equal))
(add-hook 'after-init-hook #'reset-file-name-handler-alist)

;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Move custom changes to other file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Startup to scratch
(setq inhibit-startup-screen t 
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; Remove GUI
(setq use-dialog-box nil
      confirm-kill-processes nil)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Allow all commands
(setq disabled-command-function nil)

;; Line numbers
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Cursor line
(global-hl-line-mode +1)

;; Show Parens
(setq show-paren-delay 0
      show-paren-style 'expression) ;; Expression or parenthesis
(show-paren-mode +1)

;; Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))
(unless (package-installed-p 'evil-collection)
  (package-install 'evil-collection))
(setq evil-want-keybinding nil
      evil-want-C-u-scroll t
      evil-want-minibuffer t)
(require 'evil)
(evil-mode +1)
(evil-collection-init)

;; Undo tree
(unless (package-installed-p 'undo-tree)
  (package-install 'undo-tree))
(global-undo-tree-mode)
(evil-set-undo-system #'undo-tree)

;; Prompts
(setq use-short-answers t)

;; Use spaces
(setq-default indent-tabs-mode nil)

;; Elfeed
(unless (package-installed-p 'elfeed)
  (package-install 'elfeed))
(unless (package-installed-p 'elfeed-tube)
  (package-install 'elfeed-tube))
(setq elfeed-feeds
      '("http://radar.spacebar.org/f/a/weblog/rss/1"
	"https://cp4space.hatsya.com/feed/"
	"https://eukaryotewritesblog.com/feed/"
	"https://www.subanima.org/rss/"
	"http://wingolog.org/feed/atom"
	"http://tromp.github.io/blog/atom.xml"
        "http://www.mnftiu.cc/feed/"
        "https://www.math3ma.com/blog/rss.xml"
        "https://johncarlosbaez.wordpress.com/feed/"
        "https://diagonalargument.com/feed/"
        "https://qchu.wordpress.com/feed/"
        "https://golem.ph.utexas.edu/category/atom10.xml"
        "https://peterkagey.com/feed/"
        "https://ionathan.ch/feed.xml"
        "https://cameroncounts.wordpress.com/feed/"
        "https://mathenchant.wordpress.com/feed/"))
(require 'elfeed-tube)
(elfeed-tube-setup)
(elfeed-tube-add-feeds '("https://www.youtube.com/channel/UCEOXxzW2vU0P-0THehuIIeg" ;; CD
                         "https://www.youtube.com/channel/UCYO_jab_esuFRV4b17AJtAw" ;; 3b1b
                         ))
(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "youtube\\.com"
                              :add '(video)))

;; Browser
(if (equal (getenv "HOSTNAME") "toolbx")
  (setq browse-url-browser-function 'browse-url-generic
        browse-url-generic-program "flatpak-spawn"
        browse-url-generic-args '("--host" "xdg-open"))
  (setq browse-url-browser-function 'browse-url-xdg-open))

;; Font
(setq font "-Frog-FixederSys 1x-thin-normal-normal-*-16-*-*-*-m-0-iso10646-1")
(add-to-list 'default-frame-alist (cons 'font font))
(set-face-attribute 'default t :font font)

;; Minibuffer
(setq enable-recursive-minibuffers t)

;; Dired
(setq dired-listing-switches "-ABhl --group-directories-first"
      delete-by-moving-to-trash t
      dired-vc-rename-file t
      dired-create-destination-dirs 'ask)

;; Revert files that changed on disk
(setq global-auto-revert-non-file-buffers t)
(global-auto-revert-mode +1)

;; Make scripts executable
(add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p)

;; Org
(setq org-startup-with-inline-images t)

;; No delay for docs at bottom
(setq eldoc-idle-delay 0)

;; Magit
(unless (package-installed-p 'magit)
  (package-install 'magit))

;; Git gutter
(unless (package-installed-p 'git-gutter-fringe)
  (package-install 'git-gutter-fringe))
(global-git-gutter-mode)

;; Ignore case in completion
(setq completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t)

;; Theme
(unless (package-installed-p 'kanagawa-themes)
  (package-install 'kanagawa-themes))
(setq kanagawa-themes-comment-italic t
      kanagawa-themes-keyword-italic t
      kanagawa-themes-org-agenda-height t
      kanagawa-themes-org-bold t
      kanagawa-themes-org-height t
      kanagawa-themes-org-highlight t
      kanagawa-themes-org-priority-bold t)
(load-theme 'kanagawa-wave t)
(set-face-foreground 'git-gutter:deleted "#e82424")
(set-face-foreground 'git-gutter:modified "#e98a00")
(set-face-foreground 'org-todo "#e46876")
