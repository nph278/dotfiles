;; Load guix plugins
(let ((default-directory "~/.guix-home/profile/share/emacs/site-lisp/")) (normal-top-level-add-subdirs-to-load-path))

;; evil
(setq evil-want-C-u-scroll 1)

(require 'evil)
(evil-mode 1)

;; Window movement
(evil-global-set-key 'normal (kbd "gh") 'windmove-left)
(evil-global-set-key 'normal (kbd "gl") 'windmove-right)
(evil-global-set-key 'normal (kbd "<tab>") 'org-cycle)

;; GUI
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq confirm-kill-processes nil)

;; Line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Fonts
(add-to-list 'default-frame-alist
             '(font . "Victor Mono Medium-10"))

;; Paredit
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)

;; Org
(setq org-agenda-files (list "~/Documents/all.org"))

;; Theme
(load-theme 'tango-dark) ;; switch to kanagawa when you know how
