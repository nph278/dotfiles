;; Load guix plugins
(let ((default-directory "~/.guix-home/profile/share/emacs/site-lisp/")) (normal-top-level-add-subdirs-to-load-path))

;; evil
(setq evil-want-C-u-scroll 1)

(require 'evil)
(evil-mode 1)

;; Window movement
(evil-global-set-key 'normal (kbd "gh") 'windmove-left)
(evil-global-set-key 'normal (kbd "gl") 'windmove-right)

;; Theme
(load-theme 'deeper-blue)

;; (menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
