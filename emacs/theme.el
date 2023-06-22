(setq shared-data
      (print (eval (read (with-temp-buffer
			   (insert-file-contents "~/.emacs.d/shared.el")
			   (buffer-string))))))

(defun d (key)
  (cdr (assoc key shared-data)))

(deftheme custom "Custom theme")

(custom-theme-set-faces
 'custom
 `(default                                       ((t (:background ,(d 'dark-bg) :foreground ,(d 'dark-fg)))))
 `(border                                        ((t (:background ,(d 'dark-bg) :foreground ,(d 'dark-bg)))))
 `(button                                        ((t (:foreground ,(d 'accent)))))
 `(cursor                                        ((t (:background ,(d 'accent) :foreground ,(d 'light-fg) :bold t))))
 `(error                                         ((t (:foreground ,(d 'red)))))
 `(glyphless-char                                ((t (:foreground ,(d 'light-fg)))))
 `(highlight                                     ((t (:background ,(d 'dark-bg-3) :foreground ,(d 'dark-fg)))))
 `(hl-line                                       ((t (:background ,(d 'dark-bg-2)))))
 `(homoglyph                                     ((t (:foreground ,(d 'constant)))))
 `(internal-border                               ((t (:background ,(d 'dark-bg)))))
 `(line-number                                   ((t (:foreground ,(d 'dark-bg-3)))))
 `(line-number-current-line                      ((t (:foreground ,(d 'accent) :background ,(d 'dark-bg-2) :bold t))))
 `(lv-separator                                  ((t (:foreground ,(d 'dark-fg) :background ,(d 'dark-bg)))))
 `(match                                         ((t (:background ,(d 'yellow) :foreground ,(d 'light-fg)))))
 `(menu                                          ((t (:background ,(d 'dark-bg) :foreground ,(d 'dark-fg)))))
 `(mode-line-inactive                            ((t (:background ,(d 'nil) :foreground ,(d 'dark-fg-2) :bold nil))))
 `(numbers                                       ((t (:background ,(d 'accent)))))
 `(region                                        ((t (:background ,(d 'dark-bg-3)))))
 `(success                                       ((t (:foreground ,(d 'green)))))
 `(vertical-border                               ((t (:foreground ,(d 'dark-bg-2)))))
 `(warning                                       ((t (:foreground ,(d 'yellow)))))
 `(hi-yellow                                     ((t (:background ,(d 'accent) :foreground ,(d 'light-fg)))))

 ;; Font lock
 `(font-lock-type-face                           ((t (:foreground ,(d 'type)))))
 `(font-lock-regexp-grouping-backslash           ((t (:foreground ,(d 'preprocessor)))))
 `(font-lock-keyword-face                        ((t (:foreground ,(d 'keyword) :weight semi-bold))))
 `(font-lock-warning-face                        ((t (:foreground ,(d 'yellow)))))
 `(font-lock-string-face                         ((t (:foreground ,(d 'string) :italic t))))
 `(font-lock-builtin-face                        ((t (:foreground ,(d 'builtin)))))
 `(font-lock-reference-face                      ((t (:foreground ,(d 'reference)))))
 `(font-lock-constant-face                       ((t (:foreground ,(d 'constant)))))
 `(font-lock-function-name-face                  ((t (:foreground ,(d 'function)))))
 `(font-lock-variable-name-face                  ((t (:foreground ,(d 'variable)))))
 
 `(font-lock-negation-char-face                  ((t (:foreground ,(d 'negation)))))
 
 `(font-lock-comment-face                        ((t (:foreground ,(d 'comment) :italic t))))
 `(font-lock-comment-delimiter-face              ((t (:foreground ,(d 'comment) :italic t))))
 `(font-lock-doc-face                            ((t (:foreground ,(d 'comet)))))
 `(font-lock-doc-markup-face                     ((t (:foreground ,(d 'comet)))))
 `(font-lock-preprocessor-face	                 ((t (:foreground ,(d 'preprocessor)))))

 `(info-xref                                     ((t (:foreground ,(d 'constant)))))
 `(minibuffer-prompt-end                         ((t (:foreground ,(d 'red) :background ,(d 'dark-bg)))))
 `(minibuffer-prompt                             ((t (:foreground ,(d 'yellow) :background ,(d 'dark-bg)))))
 `(epa-mark                                      ((t (:foreground ,(d 'red)))))
 `(dired-mark                                    ((t (:foreground ,(d 'red)))))
 `(trailing-whitespace                           ((t (:background ,(d 'dark-bg-2)))))
 `(mode-line                                     ((t (:bold t))))
  
 ;; elfeed
 `(elfeed-search-tag-face                        ((t (:foreground ,(d 'function)))))

 ;; message colors
 `(message-header-subject                        ((t (:foreground ,(d 'string)))))
 `(message-header-to                             ((t (:foreground ,(d 'constant)))))
 `(message-header-cc                             ((t (:foreground ,(d 'variable)))))
 `(message-header-xheader                        ((t (:foreground ,(d 'preprocessor)))))
 `(custom-link                                   ((t (:foreground ,(d 'function)))))
 `(link                                          ((t (:foreground ,(d 'function)))))

 ;; org-mode
 `(org-done                                      ((t (:foreground ,(d 'finished)))))
 `(org-meta-line                                 ((t (:background ,(d 'dark-bg) :foreground ,(d 'green)))))
 `(org-headline-done                             ((t (:foreground ,(d 'finished) :strike-through t))))
 `(org-todo                                      ((t (:foreground ,(d 'yellow) :bold t))))
 `(org-headline-todo                             ((t (:foreground ,(d 'yellow)))))
 `(org-upcoming-deadline                         ((t (:foreground ,(d 'red)))))
 `(org-footnote                                  ((t (:foreground ,(d 'comment)))))
 `(org-date                                      ((t (:foreground ,(d 'constant)))))
 `(org-level-1                                   ((t (:foreground ,(d 'red) :height 1.3 :bold t))))
 `(org-level-2                                   ((t (:foreground ,(d 'orange) :height 1.15 :bold t))))
 `(org-level-3                                   ((t (:foreground ,(d 'yellow) :height 1.05))))
 `(org-level-4                                   ((t (:foreground ,(d 'green)))))
 `(org-level-5                                   ((t (:foreground ,(d 'blue)))))
 `(org-level-6                                   ((t (:foreground ,(d 'magenta)))))

 ;; swiper
 ;; `(swiper-line-face                              ((t (:foreground carpYellow))))
 ;; `(swiper-background-match-face-1                ((t (:background surimiOrange :foreground sumiInk-0))))
 ;; `(swiper-background-match-face-2                ((t (:background crystalBlue :foreground sumiInk-0))))
 ;; `(swiper-background-match-face-3                ((t (:background boatYellow2 :foreground sumiInk-0))))
 ;; `(swiper-background-match-face-4                ((t (:background peachRed :foreground sumiInk-0))))
 ;; `(swiper-match-face-1                           ((t (:inherit 'swiper-background-match-face-1))))
 ;; `(swiper-match-face-2                           ((t (:inherit 'swiper-background-match-face-2))))
 ;; `(swiper-match-face-3                           ((t (:inherit 'swiper-background-match-face-3))))
 ;; `(swiper-match-face-4                           ((t (:inherit 'swiper-background-match-face-4))))

 ;; `(counsel-outline-default                       ((t (:foreground carpYellow))))
 ;; `(info-header-xref                              ((t (:foreground carpYellow))))
 ;; `(xref-file-header                              ((t (:foreground carpYellow))))
 ;; `(xref-match                                    ((t (:foreground carpYellow))))
 `(show-paren-mismatch                           ((t (:background ,(d 'red) :foreground ,(d 'light-fg)))))
 `(tooltip                                       ((t (:foreground ,(d 'light-fg) :background ,(d 'yellow) :bold t))))
  
 ;; company-box
 ;; `(company-tooltip                               ((t (:background sumiInk-2))))
 ;; `(company-tooltip-common                        ((t (:foreground autumnYellow))))
 ;; `(company-tooltip-quick-access                  ((t (:foreground springViolet2))))
 ;; `(company-tooltip-scrollbar-thumb               ((t (:background autumnRed))))
 ;; `(company-tooltip-scrollbar-track               ((t (:background sumiInk-2))))
 ;; `(company-tooltip-search                        ((t (:background carpYellow :foreground sumiInk-0 :distant-foreground fujiWhite))))
 ;; `(company-tooltip-selection                     ((t (:background peachRed :foreground winterRed :bold t))))
 ;; `(company-tooltip-mouse                         ((t (:background sumiInk-2 :foreground sumiInk-0 :distant-foreground fujiWhite))))
 ;; `(company-tooltip-annotation                    ((t (:foreground peachRed :distant-foreground sumiInk-1))))
 ;; `(company-scrollbar-bg                          ((t (:inherit 'tooltip))))
 ;; `(company-scrollbar-fg                          ((t (:background peachRed))))
 ;; `(company-preview                               ((t (:foreground carpYellow))))
 ;; `(company-preview-common                        ((t (:foreground peachRed :bold t))))
 ;; `(company-preview-search                        ((t (:inherit 'company-tooltip-search))))
 ;; `(company-template-field                        ((t (:inherit 'match))))

 ;; flycheck
 ;; `(flycheck-posframe-background-face             ((t (:background sumiInk-0))))
 ;; `(flycheck-posframe-face                        ((t (:background sumiInk-0))))
 ;; `(flycheck-posframe-info-face                   ((t (:background sumiInk-0 :foreground autumnGreen))))
 ;; `(flycheck-posframe-warning-face                ((t (:background sumiInk-0 :foreground lightBlue))))
 ;; `(flycheck-posframe-error-face                  ((t (:background sumiInk-0 :foreground samuraiRed))))
 ;; `(flycheck-fringe-warning                       ((t (:foreground lightBlue))))
 ;; `(flycheck-fringe-error                         ((t (:foreground samuraiRed))))
 ;; `(flycheck-fringe-info                          ((t (:foreground autumnGreen))))
 ;; `(flycheck-error-list-warning                   ((t (:foreground roninYellow :bold t))))
 ;; `(flycheck-error-list-error                     ((t (:foreground samuraiRed :bold t))))
 ;; `(flycheck-error-list-info                      ((t (:foreground waveAqua1 :bold t))))
 ;; `(flycheck-inline-error                         ((t (:foreground samuraiRed :background winterRed :italic t :bold t :height 138))))
 ;; `(flycheck-inline-info                          ((t (:foreground lightBlue :background winterBlue :italic t  :bold t :height 138))))
 ;; `(flycheck-inline-warning                       ((t (:foreground winterYellow :background carpYellow :italic t :bold t :height 138))))

 ;; indent dots
 ;; `(highlight-indent-guides-character-face        ((t (:foreground sumiInk-3))))
 ;; `(highlight-indent-guides-stack-character-face  ((t (:foreground sumiInk-3))))
 ;; `(highlight-indent-guides-stack-odd-face        ((t (:foreground sumiInk-3))))
 ;; `(highlight-indent-guides-stack-even-face       ((t (:foreground comet))))
 ;; `(highlight-indent-guides-stack-character-face  ((t (:foreground sumiInk-3))))
 ;; `(highlight-indent-guides-even-face             ((t (:foreground sumiInk-2))))
 ;; `(highlight-indent-guides-odd-face              ((t (:foreground comet))))

 ;; `(highlight-operators-face                      ((t (:foreground boatYellow2))))
 ;; `(highlight-quoted-symbol                       ((t (:foreground springGreen))))
 ;; `(highlight-numbers-face                        ((t (:foreground sakuraPink))))
 ;; `(highlight-symbol-face                         ((t (:background waveBlue-1 :foreground lightBlue))))
  
 ;; ivy
 ;; `(ivy-current-match                             ((t (:background crystalBlue :foreground sumiInk-0 :bold t))))
 ;; `(ivy-action                                    ((t (:background nil :foreground fujiWhite))))
 ;; `(ivy-grep-line-number                          ((t (:background nil :foreground springGreen))))
 ;; `(ivy-minibuffer-match-face-1                   ((t (:background nil :foreground waveRed))))
 ;; `(ivy-minibuffer-match-face-2                   ((t (:background nil :foreground springGreen))))
 ;; `(ivy-minibuffer-match-highlight                ((t (:foreground lightBlue))))
 ;; `(ivy-grep-info                                 ((t (:foreground lightBlue))))
 ;; `(ivy-grep-line-number                          ((t (:foreground springViolet2))))
 ;; `(ivy-confirm-face                              ((t (:foreground waveAqua2))))

 ;; posframe's
 ;; `(ivy-posframe                                  ((t (:background peachRed :foreground peachRed))))
 ;; `(ivy-posframe-border                           ((t (:background peachRed :foreground peachRed))))
   
 ;; lsp and lsp-ui
 ;; `(lsp-headerline-breadcrumb-path-error-face     ((t (:underline (:color springGreen :style 'wave) :foreground sumiInk-4 :background sumiInk-0))))
 ;; `(lsp-headerline-breadcrumb-path-face           ((t (:background sumiInk-0))))
 ;; `(lsp-headerline-breadcrumb-path-hint-face      ((t (:background sumiInk-0))))
 ;; `(lsp-headerline-breadcrumb-path-info-face      ((t (:background sumiInk-0))))
 ;; `(lsp-headerline-breadcrumb-separator-face      ((t (:background sumiInk-0))))
 ;; `(lsp-headerline-breadcrumb-symbols-face        ((t (:background sumiInk-0))))
 ;; `(lsp-headerline-breadcrumb-project-prefix-face ((t (:background sumiInk-0))))
 ;; `(lsp-headerline-breadcrumb-symbols-error-face  ((t (:foreground peachRed))))

 ;; `(lsp-ui-doc-background                         ((t (:background sumiInk-0 :foreground peachRed))))
 ;; `(lsp-ui-doc-header                             ((t (:background sumiInk-0 :foreground peachRed))))
 ;; `(lsp-ui-doc-border                             ((t (:background nil :foreground nil))))
 ;; `(lsp-ui-peek-filename                          ((t (:foreground lightBlue))))
 ;; `(lsp-ui-sideline-code-action                   ((t (:foreground carpYellow))))
 ;; `(lsp-ui-sideline-current-symbol                ((t (:foreground springBlue))))
 ;; `(lsp-ui-sideline-symbol                        ((t (:foreground dragonBlue))))

 ;; all-the-icons
 ;; `(all-the-icons-dgreen                          ((t (:foreground waveAqua2))))
 ;; `(all-the-icons-green                           ((t (:foreground waveAqua2))))
 ;; `(all-the-icons-dpurple                         ((t (:foreground springViolet2))))
 ;; `(all-the-icons-purple                          ((t (:foreground springViolet2))))

 ;; evil
 ;; `(evil-ex-lazy-highlight                        ((t (:foreground winterGreen :background autumnGreen :bold t))))
 ;; `(evil-ex-substitute-matches                    ((t (:foreground winterRed :background autumnRed :bold t))))
 ;; `(evil-ex-substitute-replacement                ((t (:foreground surimiOrange :strike-through nil :inherit 'evil-ex-substitute-matches))))
 ;; `(evil-search-highlight-persist-highlight-face  ((t (:background carpYellow))))

 ;; term
 `(term                                          ((t (:background ,(d 'sumiInk-0) :foreground ,(d 'fujiWhite)))))
 `(term-color-blue                               ((t (:background ,(d 'crystalBlue) :foreground ,(d 'crystalBlue)))))
 `(term-color-bright-blue                        ((t (:inherit 'term-color-blue))))
 `(term-color-green                              ((t (:background ,(d 'waveAqua2) :foreground ,(d 'waveAqua2)))))
 `(term-color-bright-green                       ((t (:inherit 'term-color-green))))
 `(term-color-black                              ((t (:background ,(d 'sumiInk-0) :foreground ,(d 'fujiWhite)))))
 `(term-color-bright-black                       ((t (:background ,(d 'sumiInk-1b) :foreground ,(d 'sumiInk-1b)))))
 `(term-color-white                              ((t (:background ,(d 'fujiWhite) :foreground ,(d 'fujiWhite)))))
 `(term-color-bright-white                       ((t (:background ,(d 'old-white) :foreground ,(d 'old-white)))))
 `(term-color-red                                ((t (:background ,(d 'peachRed) :foreground ,(d 'peachRed)))))
 `(term-color-bright-red                         ((t (:background ,(d 'springGreen) :foreground ,(d 'springGreen)))))
 `(term-color-yellow                             ((t (:background ,(d 'carpYellow) :foreground ,(d 'carpYellow)))))
 `(term-color-bright-yellow                      ((t (:background ,(d 'carpYellow) :foreground ,(d 'carpYellow)))))
 `(term-color-cyan                               ((t (:background ,(d 'springBlue) :foreground ,(d 'springBlue)))))
 `(term-color-bright-cyan                        ((t (:background ,(d 'springBlue) :foreground ,(d 'springBlue)))))
 `(term-color-magenta                            ((t (:background ,(d 'springViolet2) :foreground ,(d 'springViolet2)))))
 `(term-color-bright-magenta                     ((t (:background ,(d 'springViolet2) :foreground ,(d 'springViolet2)))))

 ;; popup
 `(popup-face                                    ((t (:inherit 'tooltip))))
 `(popup-selection-face                          ((t (:inherit 'tooltip))))
 `(popup-tip-face                                ((t (:inherit 'tooltip))))

 ;; anzu
 ;; `(anzu-match-1                                  ((t (:foreground waveAqua2 :background sumiInk-2))))
 ;; `(anzu-match-2                                  ((t (:foreground carpYellow :background sumiInk-2))))
 ;; `(anzu-match-3                                  ((t (:foreground lightBlue :background sumiInk-2))))

 ;; `(anzu-mode-line                                ((t (:foreground sumiInk-0 :background springViolet2))))
 ;; `(anzu-mode-no-match	                         ((t (:foreground fujiWhite :background peachRed))))
 ;; `(anzu-replace-to                               ((t (:foreground springBlue :background winterBlue))))
 ;; `(anzu-replace-highlight                        ((t (:foreground peachRed :background winterRed :strike-through t))))

 ;; ace
 ;; `(ace-jump-face-background                      ((t (:foreground waveBlue-2))))
 ;; `(ace-jump-face-foreground                      ((t (:foreground peachRed :background sumiInk-0 :bold t))))
  
 ;; vertico
 ;; `(vertico-multiline                             ((t (:background samuraiRed))))
 ;; `(vertico-group-title                           ((t (:background winterBlue :foreground lightBlue :bold t))))
 ;; `(vertico-group-separator                       ((t (:background winterBlue :foreground lightBlue :strike-through t))))
 ;; `(vertico-current                               ((t (:foreground carpYellow :bold t :italic t :background waveBlue-1))))

 ;; `(vertico-posframe-border                       ((t (:background sumiInk-3))))
 ;; `(vertico-posframe                              ((t (:background sumiInk-2))))
 ;; `(orderless-match-face-0                        ((t (:foreground crystalBlue :bold t))))
 ;;  
 ;; `(comint-highlight-prompt                       ((t (:background springViolet2 :foreground sumiInk-1))))
 ;; `(completions-annotations                       ((t (:background nil :foreground dragonBlue :italic t))))
  
 ;; hydra
 ;; `(hydra-face-amaranth                           ((t (:foreground autumnRed))))
 ;; `(hydra-face-blue                               ((t (:foreground springBlue))))
 ;; `(hydra-face-pink                               ((t (:foreground sakuraPink))))
 ;; `(hydra-face-red                                ((t (:foreground peachRed))))
 ;; `(hydra-face-teal                               ((t (:foreground lightBlue))))

 ;; centaur-tabs
 ;; `(centaur-tabs-active-bar-face                  ((t (:background springBlue :foreground fujiWhite))))
 ;; `(centaur-tabs-selected                         ((t (:background sumiInk-1b :foreground fujiWhite :bold t))))
 ;; `(centaur-tabs-selected-modified                ((t (:background sumiInk-1b :foreground fujiWhite))))
 ;; `(centaur-tabs-modified-marker-selected         ((t (:background sumiInk-1b :foreground autumnYellow))))
 ;; `(centaur-tabs-close-selected                   ((t (:inherit 'centaur-tabs-selected))))
 ;; `(tab-line                                      ((t (:background sumiInk-0))))

 ;; `(centaur-tabs-unselected                       ((t (:background sumiInk-0 :foreground sumiInk-4))))
 ;; `(centaur-tabs-default                          ((t (:background sumiInk-0 :foreground sumiInk-4))))
 ;; `(centaur-tabs-unselected-modified              ((t (:background sumiInk-0 :foreground peachRed))))
 ;; `(centaur-tabs-modified-marker-unselected       ((t (:background sumiInk-0 :foreground sumiInk-4))))
 ;; `(centaur-tabs-close-unselected                 ((t (:background sumiInk-0 :foreground sumiInk-4))))

 ;; `(centaur-tabs-close-mouse-face                 ((t (:background nil :foreground peachRed))))
 ;; `(centaur-tabs-default                          ((t (:background roninYellow ))))
 ;; `(centaur-tabs-name-mouse-face                  ((t (:foreground springBlue :bold t))))

 `(git-gutter:added                              ((t (:foreground ,(d 'green)))))
 `(git-gutter:deleted                            ((t (:foreground ,(d 'red)))))
 `(git-gutter:modified                           ((t (:foreground ,(d 'yellow)))))

 `(diff-hl-margin-change                         ((t (:foreground ,(d 'green) :background ,(d 'light-success)))))
 `(diff-hl-margin-delete                         ((t (:foreground ,(d 'red) :background ,(d 'light-error)))))
 `(diff-hl-margin-insert                         ((t (:foreground ,(d 'yellow) :background ,(d 'light-warning)))))

 `(bm-fringe-face                                ((t (:background ,(d 'red) :foreground ,(d 'light-fg)))))
 `(bm-fringe-persistent-face                     ((t (:background ,(d 'red) :foreground ,(d 'light-fg)))))

 `(ansi-color-green                              ((t (:foreground ,(d 'red)))))
 `(ansi-color-black                              ((t (:fackground ,(d 'black)))))
 `(ansi-color-cyan                               ((t (:foreground ,(d 'cyan)))))
 `(ansi-color-magenta                            ((t (:foreground ,(d 'magenta)))))
 `(ansi-color-blue                               ((t (:foreground ,(d 'blue)))))
 `(ansi-color-red                                ((t (:foreground ,(d 'red)))))
 `(ansi-color-white                              ((t (:foreground ,(d 'white)))))
 `(ansi-color-yellow                             ((t (:foreground ,(d 'yello)))))
 `(ansi-color-bright-white                       ((t (:foreground ,(d 'bright-white)))))

 `(tree-sitter-hl-face:attribute                 ((t (:foreground ,(d 'variable)))))
 `(tree-sitter-hl-face:escape                    ((t (:foreground ,(d 'preprocessor)))))
 `(tree-sitter-hl-face:constructor               ((t (:foreground ,(d 'function) :weight semi-bold))))
  
 `(tree-sitter-hl-face:constant                  ((t (:foreground ,(d 'constant)))))
 `(tree-sitter-hl-face:constant.builtin          ((t (:foreground ,(d 'constant) :weight semi-bold))))

 `(tree-sitter-hl-face:embedded                  ((t (:foreground ,(d 'preprocessor)))))
  
 `(tree-sitter-hl-face:function                  ((t (:foreground ,(d 'function)))))
 `(tree-sitter-hl-face:function.builtin          ((t (:foreground ,(d 'function) :italic t :background ,(d 'winterRed)))))
 `(tree-sitter-hl-face:function.call             ((t (:foreground ,(d 'function)))))
 `(tree-sitter-hl-face:function.macro            ((t (:foreground ,(d 'macro)))))
 `(tree-sitter-hl-face:function.special          ((t (:foreground ,(d 'keyword)))))
 `(tree-sitter-hl-face:function.label            ((t (:foreground ,(d 'string)))))
 
 `(tree-sitter-hl-face:method                    ((t (:foreground ,(d 'function)))))
 `(tree-sitter-hl-face:method.call               ((t (:foreground ,(d 'function)))))

 `(tree-sitter-hl-face:property                  ((t (:foreground ,(d 'variable)))))
 `(tree-sitter-hl-face:property.definition       ((t (:foreground ,(d 'variable) :italic t))))
  
 `(tree-sitter-hl-face:tag                       ((t (:foreground ,(d 'variable)))))

 `(tree-sitter-hl-face:type                      ((t (:foreground ,(d 'type) :weight semi-bold))))
 `(tree-sitter-hl-face:type.argument             ((t (:foreground ,(d 'type)))))
 `(tree-sitter-hl-face:type.builtin              ((t (:foreground ,(d 'type)))))
 `(tree-sitter-hl-face:type.parameter            ((t (:foreground ,(d 'type)))))
 `(tree-sitter-hl-face:type.super                ((t (:foreground ,(d 'type) :bold t))))

 `(tree-sitter-hl-face:variable                  ((t (:foreground ,(d 'variable) :italic t))))
 `(tree-sitter-hl-face:variable.builtin          ((t (:foreground ,(d 'variable)))))
 `(tree-sitter-hl-face:variable.parameter        ((t (:foreground ,(d 'variable) :italic t))))
 `(tree-sitter-hl-face:variable.special          ((t (:foreground ,(d 'keyword)))))
 `(tree-sitter-hl-face:variable.synthesized      ((t (:foreground ,(d 'variable)))))

 `(tree-sitter-hl-face:number                    ((t (:foreground ,(d 'constant)))))
 `(tree-sitter-hl-face:operator                  ((t (:foreground ,(d 'keyword) :bold t))))
  
 `(tree-sitter-hl-face:case-pattern              ((t (:foreground ,(d 'variable)))))
 `(tree-sitter-hl-face:variable.synthesized      ((t (:foreground ,(d 'macro)))))
 `(tree-sitter-hl-face:keyword.compiler          ((t (:foreground ,(d 'keyword) :bold t :italic t))))

 `(focus-unfocused ((t (:foreground ,(d 'dark-bg-2))))))

;;;###autoload
(and load-file-name
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(provide-theme 'custom)
