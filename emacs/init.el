;; Temporarily reduce garbage collection during startup. Inspect `gcs-done'.
(defun ambrevar/reset-gc-cons-threshold ()
  (setq gc-cons-threshold (car (get 'gc-cons-threshold 'standard-value))))
(setq gc-cons-threshold (* 64 1024 1024))
(add-hook 'after-init-hook #'ambrevar/reset-gc-cons-threshold)

;; Temporarily disable the file name handler.
(setq default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(defun ambrevar/reset-file-name-handler-alist ()
  (setq file-name-handler-alist
	(append default-file-name-handler-alist
		file-name-handler-alist))
  (cl-delete-duplicates file-name-handler-alist :test 'equal))
(add-hook 'after-init-hook #'ambrevar/reset-file-name-handler-alist)

;; Load guix plugins
(guix-emacs-autoload-packages)

;; Shared data
(setq shared-data
      (eval (read (with-temp-buffer
		    (insert-file-contents "~/.emacs.d/shared.el")
		    (buffer-string)))))

(defun d (key)
  (cdr (assoc key shared-data)))

;; No startup
(setq inhibit-startup-screen t 
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; evil
(setq evil-want-keybinding nil)
(setq evil-want-C-u-scroll 1)
(setq evil-want-minibuffer 1)
(evil-mode 1)
(evil-collection-init)

;; Guix plugins
;; (evil-global-set-key 'normal (kbd "SPC r") 'load-plugins)

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
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Cursor line
(global-hl-line-mode +1)

;; Fonts
(add-to-list 'default-frame-alist
             `(font . ,(concat (d 'font-family) " Medium-10")))

;; Paredit
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'racket-mode-hook           #'enable-paredit-mode)

;; Show Parens
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)
(show-paren-mode 1)

;; Org
(setq org-hide-emphasis-markers t)
(setq org-startup-with-inline-images t)
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
(load-theme 'custom)

;; Geiser
;; (add-hook 'scheme-mode-hook           #'geiser-mode 1)
;; (add-hook 'emacs-lisp-mode-hook       #'geiser-mode 1)
(evil-global-set-key 'normal (kbd "SPC s s") 'geiser)
(evil-global-set-key 'normal (kbd "SPC s b") 'geiser-eval-buffer)

;; Eww
(evil-global-set-key 'normal (kbd "SPC e o") 'eww)
(evil-global-set-key 'normal (kbd "SPC e h") 'eww-back-url)
(evil-global-set-key 'normal (kbd "SPC e l") 'eww-forward-url)
(evil-global-set-key 'normal (kbd "SPC e r") 'eww-reload)
(evil-global-set-key 'normal (kbd "SPC e y") 'eww-copy-page-url)
(evil-define-key 'normal eww-mode-map (kbd "SPC") nil)

;; Vterm
(evil-global-set-key 'normal (kbd "SPC v") 'multi-vterm)

;; Racket
(evil-global-set-key 'normal (kbd "SPC r r") 'racket-run)

;; Elisp
(evil-global-set-key 'normal (kbd "SPC x b") 'eval-buffer)
(evil-global-set-key 'normal (kbd "SPC x s") 'eval-last-sexp)
(evil-global-set-key 'normal (kbd "SPC x e") 'eval-expression)

;; git gutter
(global-git-gutter-mode)

;; Magit
(evil-global-set-key 'normal (kbd "SPC m s") 'magit-status)

;; Project
(evil-global-set-key 'normal (kbd "SPC p f") 'project-find-file)
(evil-global-set-key 'normal (kbd "SPC p r") 'project-find-regexp)
(evil-global-set-key 'normal (kbd "SPC p p") 'project-switch-project)
(evil-global-set-key 'normal (kbd "SPC p d") 'project-dired)
(defun project-path (name) `(,(concat "~/Projects/" name "/")))
(setq project--list (mapcar #'project-path (cddr (directory-files "~/Projects"))))
(defun create-project (l name)
  (interactive "P\nsProject name: ")
  (let ((path (project-path name)))
    (mkdir path)
    (project-switch-project path)))
(evil-global-set-key 'normal (kbd "SPC p n") 'create-project)

;; Persepective
;; (setq persp-suppress-no-prefix-key-warning t)
;; (persp-mode)
;; (persp-rename "code")
;; (evil-global-set-key 'normal (kbd "SPC w o") 'persp-switch)
;; (evil-global-set-key 'normal (kbd "SPC w d") 'persp-kill)
;; (evil-global-set-key 'normal (kbd "SPC w r") 'persp-rename)

;; Rust
(setq rust-format-on-save t)
(add-hook 'rust-mode-hook #'prettify-symbols-mode)

;; Ligatures
(ligature-set-ligatures 't '("www"))
(ligature-set-ligatures '(rust-mode) '("<=" ">=" "==" "!=" "::" "&&" "++"))
(ligature-set-ligatures '(scheme-mode emacs-lisp-mode lisp-mode racket-mode) '("->" ";;"))
(ligature-set-ligatures '(html-mode nxml-mode web-mode) '("<!--" "-->" "</>" "</" "/>" "://"))
(ligature-set-ligatures '(org-mode) '("::" "->" "<-" "<->" "-->" "<--" "=>" "<=" "<=>" "==>" "<=="))
(global-ligature-mode)

;; Ebooks
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; Pdf-tools
(pdf-tools-install)
(setq-default pdf-view-display-size 'fit-page)
(setq pdf-view-resize-factor 1.1)
(setq pdf-annot-activate-created-annotations t)

;; Tex
(setq tex-auto-save t)
(setq tex-parse-self t)
(setq tex-master nil)
(setq tex-view-program-selection '((output-pdf "pdf-tools")))

;; Guix
(evil-global-set-key 'normal (kbd "SPC g s") 'guix)
(defun guix-home-reconfigure ()
  (interactive)
  (shell-command "guix home reconfigure home.scm"))
(evil-global-set-key 'normal (kbd "SPC g r") 'guix-home-reconfigure)

;; Elfeed
(defun elfeed-update-view ()
  (interactive)
  (elfeed-update)
  (elfeed))
(evil-global-set-key 'normal (kbd "SPC f") 'elfeed-update-view)
(setq elfeed-feeds
      '("http://radar.spacebar.org/f/a/weblog/rss/1"
	"http://funcall.blogspot.com/feeds/posts/default"
	"https://cp4space.hatsya.com/feed/"
	"https://eukaryotewritesblog.com/feed/"
	"https://www.subanima.org/rss/"
	"http://wingolog.org/feed/atom"
	"https://scottaaronson.blog/?feed=rss2"))

;; Dired
(defun dired-root () (interactive) (dired "~"))
(evil-global-set-key 'normal (kbd "SPC d") 'dired-root)
(setq dired-listing-switches "-aBhl  --group-directories-first")
(evil-define-key 'normal dired-mode-map (kbd "SPC") nil)
