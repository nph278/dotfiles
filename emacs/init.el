;;; Temporarily reduce garbage collection during startup. Inspect `gcs-done'.
(defun ambrevar/reset-gc-cons-threshold ()
  (setq gc-cons-threshold (car (get 'gc-cons-threshold 'standard-value))))
(setq gc-cons-threshold (* 64 1024 1024))
(add-hook 'after-init-hook #'ambrevar/reset-gc-cons-threshold)

;;; Temporarily disable the file name handler.
(setq default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(defun ambrevar/reset-file-name-handler-alist ()
  (setq file-name-handler-alist
	(append default-file-name-handler-alist
		file-name-handler-alist))
  (cl-delete-duplicates file-name-handler-alist :test 'equal))
(add-hook 'after-init-hook #'ambrevar/reset-file-name-handler-alist)

;; Load guix plugins
(let ((default-directory "~/.guix-home/profile/share/emacs/site-lisp/")) (normal-top-level-add-subdirs-to-load-path))

;; evil
(setq evil-want-keybinding nil)
(setq evil-want-C-u-scroll 1)
(evil-mode 1)
(evil-collection-init)

;; Undo-tree
(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)

;; Buffers
(evil-global-set-key 'normal (kbd "SPC w h") 'windmove-left)
(evil-global-set-key 'normal (kbd "SPC w l") 'windmove-right)
(evil-global-set-key 'normal (kbd "SPC w k") 'windmove-up)
(evil-global-set-key 'normal (kbd "SPC w j") 'windmove-down)
(evil-global-set-key 'normal (kbd "SPC w J") 'split-window-below)
(evil-global-set-key 'normal (kbd "SPC w L") 'split-window-right)

;; GUI
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq use-dialog-box nil)
(setq confirm-kill-processes nil)

;; Line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Cursor line
(global-hl-line-mode +1)

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
(setq show-paren-delay 0)

;; Org
(setq org-agenda-files (list "~/Roam"))
(defun evil-org-settings () (evil-org-set-key-theme '(textobjects insert navigation additional shift)))
(add-hook 'evil-org-mode-hook         #'evil-org-settings nil 'local)
(add-hook 'org-mode-hook              #'evil-org-mode)
(add-hook 'org-mode-hook              #'org-fragtog-mode)
(evil-global-set-key 'normal (kbd "SPC o t") 'org-todo)
(evil-global-set-key 'normal (kbd "SPC o a") 'org-agenda)
(evil-global-set-key 'normal (kbd "SPC o b") 'org-insert-structure-template)
(evil-global-set-key 'normal (kbd "SPC o .") 'org-time-stamp)
(evil-global-set-key 'normal (kbd "SPC o s") 'org-schedule)
(evil-global-set-key 'normal (kbd "SPC o d") 'org-deadline)
(evil-define-key 'normal org-mode-map (kbd "RET") 'org-open-at-point)

;; Org-roam
(setq org-roam-directory "~/Roam")
(org-roam-db-autosync-mode)
(evil-global-set-key 'normal (kbd "SPC n l") 'org-roam-buffer-toggle)
(evil-global-set-key 'normal (kbd "SPC n f") 'org-roam-node-find)
(evil-global-set-key 'normal (kbd "SPC n i") 'org-roam-node-insert)
(setq org-todo-keywords '((sequence "TODO(t)" "WAIT(w)" "PLAN(p)" "|" "DONE(d)" "STOP(s)")))

;; Theme
(setq custom-safe-themes t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'kanagawa)

;; Geiser
;; (add-hook 'scheme-mode-hook           #'geiser-mode 1)
;; (add-hook 'emacs-lisp-mode-hook       #'geiser-mode 1)
(evil-global-set-key 'normal (kbd "SPC g s") 'geiser)
(evil-global-set-key 'normal (kbd "SPC g b") 'geiser-eval-buffer)

;; Eww
(evil-global-set-key 'normal (kbd "SPC e o") 'eww)
(evil-global-set-key 'normal (kbd "SPC e h") 'eww-back-url)
(evil-global-set-key 'normal (kbd "SPC e l") 'eww-forward-url)
(evil-global-set-key 'normal (kbd "SPC e r") 'eww-reload)
(evil-global-set-key 'normal (kbd "SPC e y") 'eww-copy-page-url)

;; Vterm
(evil-global-set-key 'normal (kbd "SPC v") 'vterm)

;; Elisp
(evil-global-set-key 'normal (kbd "SPC x b") 'eval-buffer)
(evil-global-set-key 'normal (kbd "SPC x s") 'eval-last-sexp)
