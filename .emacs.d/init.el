;; Temporarily reduce garbage collection during startup
(defun reset-gc-cons-threshold ()
  (setq gc-cons-threshold (car (get 'gc-cons-threshold 'standard-value))))
(setq gc-cons-threshold (* 64 1024 1024))
(add-hook 'after-init-hook #'reset-gc-cons-threshold)

;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Move custom changes to other file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
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
(use-package kanagawa-themes
  :ensure t
  :custom
  (kanagawa-themes-org-highlight t)
  :custom-face
  (git-gutter:added ((t (:foreground "#76946A"))))
  (git-gutter:deleted ((t (:foreground "#C34043"))))
  (git-gutter:modified ((t (:foreground "#DCA561"))))
  (corfu-default ((t (:background "#1A1A22")))) ;; bg-m1
  (corfu-current ((t (:foreground nil :background "#363646")))) ;; bg-p2
  (corfu-deprecated ((t (:inherit nil))))
  (corfu-bar ((t (:background nil :inherit tooltip))))
  (corfu-border ((t (:background "#1F1F28")))) ;; bg
  :config
  (load-theme 'kanagawa-wave t))

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
(use-package evil
  :ensure t
  :custom
  (evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
  (evil-want-minibuffer t)
  :config
  (evil-mode +1))
(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

;; Undo tree
(use-package undo-tree
  :ensure t
  :after evil
  :config
  (global-undo-tree-mode +1)
  (evil-set-undo-system #'undo-tree))

;; Prompts
(setq use-short-answers t)

;; Use spaces
(setq-default indent-tabs-mode nil)

;; Elfeed
(use-package elfeed
  :ensure t
  :custom
  (elfeed-feeds
   '(("http://radar.spacebar.org/f/a/weblog/rss/1" cs math)
     ("https://cp4space.hatsya.com/feed/" math)
     "https://eukaryotewritesblog.com/feed/"
     "https://www.subanima.org/rss/"
     ("http://wingolog.org/feed/atom" cs)
     ("http://tromp.github.io/blog/atom.xml" cs)
     "http://www.mnftiu.cc/feed/"
     ("https://www.math3ma.com/blog/rss.xml" math)
     ("https://johncarlosbaez.wordpress.com/feed/" math)
     ("https://diagonalargument.com/feed/" math)
     ("https://qchu.wordpress.com/feed/" math)
     ("https://golem.ph.utexas.edu/category/atom10.xml" math)
     ("https://peterkagey.com/feed/" math)
     "https://ionathan.ch/feed.xml"
     ("https://cameroncounts.wordpress.com/feed/" math)
     ("https://mathenchant.wordpress.com/feed/" math))))

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
(use-package magit
  :ensure t)

;; Git gutter
(use-package git-gutter-fringe
  :ensure t
  :config
  (global-git-gutter-mode +1))

;; Completion
(setq completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-auto-select 'second-tab
      tab-always-indent 'complete
      completion-styles '(basic initials substring flex))

;; Keepass-mode (with hacks bc it is unmaintained)
(use-package keepass-mode
  :ensure t)
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
(which-key-mode +1)

;; Whitespace
(setq whitespace-style '(face trailing tabs)
      require-final-newline t)
(add-hook 'prog-mode-hook #'whitespace-mode)

;; Editorconfig
(editorconfig-mode +1)

;; Rust
(use-package rust-mode
  :ensure t
  :custom
  (rust-format-on-save t))

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

;; Native compilation
(setq native-comp-async-query-on-exit t)

;; Ellipsis
(setq truncate-string-ellipsis "…")

;; Start in home directory
(setq default-directory "~/")

;; Corfu
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :custom
  (corfu-cycle t))

;; Smartparens
(use-package smartparens
  :ensure t
  :hook ((lisp-mode emacs-lisp-mode scheme-mode) . smartparens-strict-mode)
  :config
  (require 'smartparens-config))
(use-package evil-smartparens
  :ensure t
  :hook (smartparens-enabled))

;; Package upgrade guard
(use-package package-upgrade-guard
  :vc (:url "https://github.com/kn66/package-upgrade-guard.el.git"
            :rev :newest)
  :config
  (package-upgrade-guard-mode +1))
