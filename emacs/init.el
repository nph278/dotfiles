;; == Startup ==

;; Temporarily reduce garbage collection during startup. Inspect `gcs-done'.
(defun ambrevar/reset-gc-cons-threshold ()
  (setq gc-cons-threshold (car (get 'gc-cons-threshold 'standard-value))))
(setq gc-cons-threshold (* 64 1024 1024))
(add-hook 'after-init-hook #'ambrevar/reset-gc-cons-threshold)

;; Temporarily disable the file name handler.
(setq default-file-name-handler-alist file-name-handler-alist
      file-name-handler-alist nil)
(defun ambrevar/reset-file-name-handler-alist ()
  (setq file-name-handler-alist
	(append default-file-name-handler-alist
		file-name-handler-alist))
  (cl-delete-duplicates file-name-handler-alist :test 'equal))
(add-hook 'after-init-hook #'ambrevar/reset-file-name-handler-alist)

;; Load plugins
(guix-emacs-autoload-packages)


;; == Appearance ==

;; Shared data
(setq shared-data
      (eval (read (with-temp-buffer
		    (insert-file-contents "~/.emacs.d/shared.el")
		    (buffer-string)))))
(defun d (key)
  (cdr (assoc key shared-data)))

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

;; Fonts
(add-to-list 'default-frame-alist
             `(font . ,(concat (d 'font-family) " Medium-10")))

;; Theme
(setq custom-safe-themes t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'custom)

;; Line numbers
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Cursor line
(global-hl-line-mode +1)

;; Show Parens
(setq show-paren-delay 0
      show-paren-style 'parenthesis)
(show-paren-mode +1)

;; Ligatures
(ligature-set-ligatures 't '("www"))
(ligature-set-ligatures '(rust-mode) '("<=" ">=" "==" "!=" "::" "&&" "++"))
(ligature-set-ligatures '(scheme-mode emacs-lisp-mode lisp-mode racket-mode) '("->" ";;" "=="))
(ligature-set-ligatures '(html-mode nxml-mode web-mode) '("<!--" "-->" "</>" "</" "/>" "://"))
(ligature-set-ligatures '(org-mode) '("::" "->" "<-" "<->" "-->" "<--" "=>" "<=" "<=>" "==>" "<=="))
(global-ligature-mode)

;; Mode line
(setq mode-line-format
      '("%e"
	mode-line-front-space
	"%b:%l "
	(vc-mode vc-mode)
	"  "
	mode-line-modes
	mode-line-misc-info
	mode-line-end-spaces))

;; Colors
(add-hook 'prog-mode-hook #'rainbow-mode)


;; == Editing ==

;; Evil
(setq evil-want-keybinding nil
      evil-want-C-u-scroll t
      evil-want-minibuffer t)
(evil-mode +1)
(evil-collection-init)

;; Undo tree
(global-undo-tree-mode)
(evil-set-undo-system #'undo-tree)


;; == Files ==

;; Dired
(setq dired-listing-switches "-ABhl  --group-directories-first"
      delete-by-moving-to-trash t)
(evil-define-key 'normal dired-mode-map (kbd "SPC") nil)

;; Git gutter
(global-git-gutter-mode +1)

;; Projects
(defun project-path (name) `(,(concat "~/Projects/" name "/")))
(setq project--list (mapcar #'project-path (cddr (directory-files "~/Projects"))))


;; == Text ==

;; Org
(setq org-hide-emphasis-markers t
      org-startup-with-inline-images t
      org-todo-keywords '((sequence "TODO(t)" "WAIT(w)" "PLAN(p)" "|" "DONE(d)" "STOP(s)")))
(defun evil-org-settings ()
  (evil-org-set-key-theme '(textobjects insert navigation additional shift)))
(add-hook 'evil-org-mode-hook                     #'evil-org-settings nil 'local)
(add-hook 'org-mode-hook                          #'evil-org-mode)
(add-hook 'org-mode-hook                          #'org-fragtog-mode)
(evil-define-key 'normal org-mode-map (kbd "RET") #'org-open-at-point)

;; Ebooks
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; Pdf-tools
(pdf-tools-install)
(setq-default pdf-view-display-size 'fit-page)
(setq pdf-view-resize-factor 1.1
      pdf-annot-activate-created-annotations t)

;; Tex
(setq tex-auto-save t
      tex-parse-self t
      tex-master nil
      tex-view-program-selection '((output-pdf "pdf-tools")))


;; == Web ==

;; Elfeed
(setq elfeed-feeds
      '("http://radar.spacebar.org/f/a/weblog/rss/1"
	"http://funcall.blogspot.com/feeds/posts/default"
	"https://cp4space.hatsya.com/feed/"
	"https://eukaryotewritesblog.com/feed/"
	"https://www.subanima.org/rss/"
	"http://wingolog.org/feed/atom"
	"https://scottaaronson.blog/?feed=rss2"
	"https://aliquote.org/index.xml"))
(defun elfeed-update-view ()
  (interactive)
  (elfeed-update)
  (elfeed))
(evil-global-set-key 'normal (kbd "SPC f") #'elfeed-update-view)
(evil-define-key 'normal elfeed-show-mode-map (kbd "TAB") #'dired-open-external)

;; Eww
(evil-global-set-key 'normal (kbd "SPC e o") #'eww)
(evil-define-key 'normal eww-mode-map (kbd "g y") #'eww-copy-page-url)
(evil-define-key 'normal eww-mode-map (kbd "SPC") nil)


;; == Programming ==

;; Commenting
;; (defun comment-dwim-line ()
;;   (interactive)
;;   (evil-visual-line)
;;   (comment-dwim t))
(evil-define-key 'visual prog-mode-map (kbd "g c")   #'comment-dwim)
;; (evil-define-key 'normal prog-mode-map (kbd "g c c") #'comment-dwim-line)

;; Paredit
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'racket-mode-hook           #'enable-paredit-mode)

;; Racket
(evil-global-set-key 'normal (kbd "SPC r r") #'racket-run)

;; Rust
(setq rust-format-on-save t)
(add-hook 'rust-mode-hook #'prettify-symbols-mode)

;; Guix
(evil-global-set-key 'normal (kbd "SPC g s") #'guix)
(defun guix-home-reconfigure ()
  (interactive)
  (shell-command "guix home reconfigure home.scm"))
(evil-global-set-key 'normal (kbd "SPC g r") #'guix-home-reconfigure)

;; == Tools ==

;; Vterm
(evil-global-set-key 'normal (kbd "SPC v") #'multi-vterm)

;; Password store
(evil-global-set-key 'normal (kbd "SPC k") #'pass)
