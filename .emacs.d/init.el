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

;; Allow all commands
(setq disabled-command-function nil)

;; Line numbers
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Cursor line
(global-hl-line-mode +1)

;; Show Parens
(setq show-paren-delay 0
      show-paren-style 'parens) ;; Expression or parenthesis
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

;; Toolbx
(setq in-toolbox (string= (getenv "HOSTNAME") "toolbx"))

;; Open urls
(if in-toolbox
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
(defun set-cursor-to-bar ()
  (setq cursor-type 'bar))
(add-hook 'minibuffer-setup-hook #'set-cursor-to-bar)

;; Dired
(setq dired-listing-switches "-ABhl --group-directories-first"
      delete-by-moving-to-trash t
      dired-vc-rename-file t
      dired-create-destination-dirs 'ask
      dired-dwim-target t)

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
(set-face-foreground 'git-gutter:deleted "#e82424")
(set-face-foreground 'git-gutter:modified "#e98a00")

;; Completion
(setq completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-auto-select 'second-tab
      tab-always-indent 'complete
      completion-styles '(basic initials substring))

;; Vertico
;; (unless (package-installed-p 'vertico)
;;   (package-install 'vertico))
;; (vertico-mode)

;; Keepass-mode (with hacks bc it is unmaintained)
(unless (package-installed-p 'keepass-mode)
  (package-install 'keepass-mode))
(require 'keepass-mode)
;; Fix Egrep warning
(defun my-keepass-mode-command (group command)
  "Generate KeePass COMMAND to run, on GROUP."
  (format "echo %s | \
           keepassxc-cli %s %s %s 2>&1 | \
           grep -Ev '[Insert|Enter] password to unlock %s'"
          (shell-quote-argument keepass-mode-password)
          command
          keepass-mode-db
          group
          keepass-mode-db))
(advice-add 'keepass-mode-command :override #'my-keepass-mode-command)
;; Show recursive view
;; (defun my-keepass-mode-get-entries (group)
;;   "Get entry list for GROUP."
;;   (nbutlast (split-string (shell-command-to-string (keepass-mode-command (keepass-mode-quote-unless-empty group) "ls -R")) "\n") 1))
;; (advice-add 'keepass-mode-get-entries :override #'my-keepass-mode-get-entries)
;; Quit with q
(defun my-keepass-quit ()
  (interactive)
  (if (string= keepass-mode-group-path "")
      (quit-window)
      (keepass-mode-back)))
(add-hook 'keepass-mode-hook
          (lambda ()
            (evil-local-set-key 'normal (kbd "RET") #'keepass-mode-select)
            (evil-local-set-key 'normal (kbd "y") #'keepass-mode-copy-password)
            (evil-local-set-key 'normal (kbd "Y") #'keepass-mode-copy-username)
            (evil-local-set-key 'normal (kbd "q") #'my-keepass-quit)))

;; Keybind hints
(setq which-key-show-early-on-C-h t
      which-key-idle-delay 0.5
      which-key-idle-secondary-delay 0
      which-key-allow-evil-operators t)
(which-key-mode)

;; Whitespace
(setq whitespace-style '(face trailing tabs)
      require-final-newline t)
(add-hook 'prog-mode-hook #'whitespace-mode)

;; Editorconfig
(editorconfig-mode)

;; Rust
(unless (package-installed-p 'rust-mode)
  (package-install 'rust-mode))
(setq rust-format-on-save t)

;; Commenting
(defun comment-indent-append ()
  (interactive)
  (comment-indent)
  (evil-append-line 1))
(add-hook 'prog-mode-hook
          (lambda ()
            (evil-local-set-key 'normal (kbd "gcc") #'comment-line)
            (evil-local-set-key 'normal (kbd "gcA") #'comment-indent-append)
            (evil-local-set-key 'visual (kbd "gc") #'comment-or-uncomment-region)))
