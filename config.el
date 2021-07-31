(use-package emacs
  :preface
  (defvar ian/indent-width 4) ; change this value to your preferred width
  :config
  (setq frame-title-format '("Clojuremacs")
        frame-resize-pixelwise t
        default-directory "~/")

  (tool-bar-mode -1)
  (menu-bar-mode -1)

  ;; Disable warning "cl package is deprecated"
  (setq byte-compile-warnings '(cl-functions))

  ;; better scrolling experience
  (setq scroll-margin 0
        scroll-conservatively 101 ; > 100
        scroll-preserve-screen-position t
        auto-window-vscroll nil)

  ;; Default frame size / position
  (add-to-list 'default-frame-alist '(height . 80))
  (add-to-list 'default-frame-alist '(width . 240))
  (add-to-list 'default-frame-alist '(left . 740))
  (add-to-list 'default-frame-alist '(top . 140))

  ;; No welcome screen
  (setq inhibit-startup-screen t)

  ;; Always use spaces for indentation
  (setq-default indent-tabs-mode nil
                tab-width ian/indent-width))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;(use-package auto-package-update
;;  :defer 10
;;  :config
;;  (setq auto-package-update-delete-old-versions t)
;;  (setq auto-package-update-hide-results t)
;;  (auto-package-update-maybe))

(use-package zenburn-theme)
(load-theme 'zenburn t)

(use-package company)

(use-package ag)
(use-package helm-ag)

;; Cider
(use-package cider
  :ensure t)

(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)

;; Paredit
(use-package paredit
  :ensure t)
;; Lispy
(use-package lispy
  :ensure t)
;; Smartparens
(use-package smartparens)
(use-package clj-refactor
 :init (clj-refactor-mode 1) (yas-minor-mode 1))

(use-package all-the-icons)

(use-package shelldon
  :straight (shelldon :type git
                      :host github
                      :repo "Overdr0ne/shelldon"
                      :branch "master"))

(use-package projectile
  :ensure t
  :init (projectile-mode +1))

(use-package helm
  :config
  (helm-mode 1))
(use-package helm-projectile)

(use-package winum
  :config
  (winum-mode))

;; TODO fold python,clojure by default
(use-package origami
  :init
  (add-hook 'prog-mode-hook #'origami-mode))

(use-package rainbow-delimiters)

;; TODO https://www.reddit.com/r/emacs/comments/5p3njk/help_terminal_zsh_control_characters_in_prompt/
(use-package shell-pop
  :defer t
  :custom
  (shell-pop-universal-key "C-t")
  (shell-pop-window-size 30)
  (shell-pop-window-position "bottom")
  (shell-pop-term-shell "/bin/zsh"))

(setq shell-file-name "/bin/zsh")
(setq system-uses-terminfo nil)

(use-package which-key
  :diminish
  :defer 1
  :config (which-key-mode)
	(which-key-setup-side-window-bottom)
	(setq which-key-idle-delay 0.05))

(use-package diminish
  :defer 5
	:config
	(diminish  'org-indent-mode))

(use-package magit
  :bind ("C-x g" . magit-status)
  :config (add-hook 'with-editor-mode-hook #'evil-insert-state))

(use-package htmlize :defer t)

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package dash)

(use-package s)

(use-package f)

(use-package undo-tree
  :diminish
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t))

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))
(use-package evil-commentary)
(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-company-use-tng nil)
  (evil-collection-init))
(use-package evil-magit)

(load (concat (file-name-directory load-file-name) "functions.el"))

(use-package awesome-tab
  :load-path "local/awesome-tab"
  :config
  (awesome-tab-mode t))

(use-package general)
(require 'general)
;; Space
(general-create-definer my-leader-def
                        :prefix "SPC")
;; Tab
(general-create-definer my-extra-def
                        :prefix "TAB")
;; Comma
(general-create-definer my-mode-def
                        :prefix ",")

(global-set-key (kbd "C-s") 'save-buffer)

;; Tab
(my-extra-def
 :keymaps 'normal
 "TAB" 'origami-recursively-toggle-node
 "SPC" 'awesome-tab-ace-jump
 "au" 'undo-tree-visualize
 "bb" 'helm-buffers-list
 "bd" 'evil-delete-buffer
 "bf" 'origami-toggle-all-nodes
 "bS" 'my/switch-to-scratch-buffer
 "bN" 'my/new-empty-buffer
 "bs" 'save-buffer
 "ff" 'helm-find-files
 "gg" 'magit-status
 "h" 'awesome-tab-move-current-tab-to-left
 "l" 'awesome-tab-move-current-tab-to-right
 "ps" 'helm-projectile-ag
 "pf" 'helm-projectile-find-file
 "pb" 'helm-projectile-display-buffer
 "wd" 'delete-window
 "w/" 'split-window-horizontally
 "w-" 'split-window-vertically
 "x" 'kill-current-buffer
 "z+" 'text-scale-increase
 "z-" 'text-scale-decrese
 )

 ;; clj-refactor
(my-leader-def
 :keymaps '(normal visual)
 "rad" 'cljr-add-declaration
 "rai" 'cljr-add-import-to-ns
 "ram" 'cljr-add-missing-libspec
 "rap" 'cljr-add-project-dependency
 "rar" 'cljr-add-require-to-ns
 "ras" 'cljr-add-stubs
 "rau" 'cljr-add-use-to-ns
 "rci" 'clojure-cycle-if
 "rcn" 'cljr-clean-ns
 "rcp" 'clojure-cycle-privacy
 "rcs" 'cljr-change-function-signature
 "rct" 'cljr-cycle-thread
 "rdk" 'cljr-destructure-keys
 "rec" 'cljr-extract-constant
 "red" 'cljr-extract-def
 "ref" 'cljr-extract-function
 "rel" 'cljr-expand-let
 "rfe" 'cljr-create-fn-from-example
 "rfu" 'cljr-find-usages
 "rhd" 'cljr-hotload-dependency
 "ril" 'cljr-introduce-let
 "ris" 'cljr-inline-symbol
 "rmf" 'cljr-move-form
 "rml" 'cljr-move-to-let
 "rpc" 'cljr-project-clean
 "rpf" 'cljr-promote-function
 "rrf" 'cljr-rename-file-or-dir
 "rrl" 'cljr-remove-let
 "rrm" 'cljr-require-macro
 "rrs" 'cljr-rename-symbol
 "rsc" 'cljr-show-changelog
 "rsp" 'cljr-sort-project-dependencies
 "rsr" 'cljr-stop-referring
 "rtf" 'clojure-thread-first-all
 "rth" 'clojure-thread
 "rtl" 'clojure-thread-last-all
 "rua" 'clojure-unwind-all
 "rup" 'cljr-update-project-dependencies
 "ruw" 'clojure-unwind
)

;; Top
(my-leader-def
 :keymaps '(normal visual)
 "TAB" 'my/alternate-buffer
 "SPC" 'helm-M-x
 "1" 'winum-select-window-1
 "2" 'winum-select-window-2
 "3" 'winum-select-window-3
 "4" 'winum-select-window-4
 "5" 'winum-select-window-5
 "6" 'winum-select-window-6
 "7" 'winum-select-window-7
 "8" 'winum-select-window-8
 "9" 'winum-select-window-9
 "0" 'treemacs-select-window
 "$" 'shelldon-hist
 "!" 'shelldon
 "^" 'lispy-beginning-of-defun
 "=" 'lispy-tab
 ";" 'evil-commentary
 "c" 'lispy-clone
 "C" 'lispy-convolute
 "b" 'lispy-forward-barf-sexp
 "B" 'lispy-backward-barf-sexp
 "h" 'lispy-move-right
 "H" 'lispy-move-left
 "j" 'lispy-move-down
 "J" 'lispy-move-up
 "k" 'lispy-down-slurp
 "K" 'lispy-up-slurp
 "o" 'lispy-parens-down
 "s" 'lispy-forward-slurp-sexp
 "S" 'lispy-backward-slurp-sexp
 "t" 'sp-transpose-sexp
 "u" 'lispy-raise-some
 "w" 'paredit-wrap-round
 "W" 'paredit-splice-sexp
 "x" 'sp-kill-sexp
 "y" 'lispy-new-copy
 )

;; Normal mode remap
(evil-define-key nil evil-normal-state-map
  "B" 'lispy-forward-barf-sexp
  "C" 'lispy-backward-barf-sexp
  "s" 'lispy-forward-slurp-sexp
  "S" 'lispy-backward-slurp-sexp
  "Y" 'lispy-new-copy)

;; Clojure
(my-mode-def
 :keymaps 'normal
 "'" 'cider-jack-in)

(use-package treemacs
  :ensure t
  :defer t
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-read-string-input             'from-child-frame
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         35
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)
    
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))))

(use-package treemacs-evil
  :after treemacs evil
  :ensure t)

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(treemacs)
