;; Load guix plugins
(let ((default-directory "~/.guix-home/profile/share/emacs/site-lisp/")) (normal-top-level-add-subdirs-to-load-path))

;; EVIL
(require 'evil)
(evil-mode 1)

;; Theme
(load-theme 'deeper-blue)

(tool-bar-mode 0)
