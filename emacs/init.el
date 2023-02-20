;; Load guix plugins
(let ((default-directory "~/.guix-home/profile/share/emacs/site-lisp/")) (normal-top-level-add-subdirs-to-load-path))

;; evil
(setq evil-want-C-u-scroll 1)
(require 'evil)
(evil-mode 1)

;; Undo-tree
(require 'undo-tree)
(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)

;; Window movement
(evil-global-set-key 'normal (kbd "gh") 'windmove-left)
(evil-global-set-key 'normal (kbd "gl") 'windmove-right)

;; GUI
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq use-dialog-box nil)
(setq confirm-kill-processes nil)

;; Line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Fonts
(add-to-list 'default-frame-alist
             '(font . "Victor Mono Medium-10"))

;; Paredit
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)

;; Org
(setq org-agenda-files (list "~/Roam"))
(defun evil-org-settings () (evil-org-set-key-theme '(textobjects insert navigation additional shift)))
(add-hook 'evil-org-mode-hook         #'evil-org-settings nil 'local)
(add-hook 'org-mode-hook              #'evil-org-mode)

;; Org-roam
(setq org-roam-directory "~/Roam")
(org-roam-db-autosync-mode)
(evil-global-set-key 'normal (kbd "C-c n f") 'org-roam-node-find)
(evil-global-set-key 'normal (kbd "C-c n i") 'org-roam-node-insert)
(evil-global-set-key 'insert (kbd "C-c n f") 'org-roam-node-find)
(evil-global-set-key 'insert (kbd "C-c n i") 'org-roam-node-insert)
(setq org-todo-keywords '((sequence "TODO(t)" "WAIT(w)" "PLAN(p)" "|" "DONE(d)" "STOP(s)")))

;; Theme
(load-theme 'tango-dark) ;; switch to kanagawa when you know how
