(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; keep the installed packages in .emacs.d
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)
;; update the package metadata is the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; the toolbar is just a waste of valuable screen estate
;; in a tty tool-bar-mode does not properly auto-load, and is
;; already disabled anyway
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; Delete word instead of symbol
(global-set-key (kbd "<backspace>") 'backward-kill-word)

;;(global-font-lock-mode -1)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable startup screen
(setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode t))

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance
(setq-default c-basic-offset     4)
(setq-default standart-indent    4)
(setq-default js-indent-level 2)
(setq-default typescript-indent-level 2)
(setq-default css-indent-offset 4)
(setq tab-stop-list '( 2 4 6 8 10 12))
(setq require-final-newline t)

;; Newline at end of file
(setq require-final-newline t)

;; delete the selection with a keypress
(delete-selection-mode t)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(use-package dired
  :config
  ;; dired - reuse current buffer by pressing 'a'
  (put 'dired-find-alternate-file 'disabled nil)

  ;; always delete and copy recursively
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)

  ;; if there is a dired buffer displayed in the next window, use its
  ;; current subdir, instead of the current subdir of this dired buffer
  (setq dired-dwim-target t))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package projectile
  :ensure t
  :config
  (global-set-key (kbd "C-c p") 'projectile-command-map)
  (global-set-key (kbd "M-p") 'projectile-find-file)
  (projectile-mode +1))

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode))
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-script-padding 0)
  ;; Vue-mode setup
  :config
  (define-derived-mode vue-mode web-mode "Vue")
  (add-to-list 'auto-mode-alist '("\\.vue\\'" . vue-mode)))

(use-package css-mode
  :custom
  (css-indent-offset 2))

(use-package god-mode
  :ensure t)

(require 'god-mode)
(god-mode)
(global-set-key (kbd "<escape>") #'god-mode-all)

(use-package gnu-elpa-keyring-update
  :ensure t)

(use-package zenburn-theme
  :ensure t
  :load-path "themes"
  :init
  :config
  (load-theme 'zenburn t)
  )

;;; Appearance
(defun rc/get-default-font ()
  (cond
   ((eq system-type 'windows-nt) "Consolas-13")
   ((eq system-type 'gnu/linux) "Iosevka-13")))

(add-to-list 'default-frame-alist `(font . ,(rc/get-default-font)))
;; (use-package vertico
;;  :ensure t
;;  :init
;;  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
;;  )

(use-package ido-vertical-mode
  :ensure t
  )

(setq ido-vertical-define-keys 'C-n-and-C-p-only)

(require 'ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)


(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)


(use-package crux
  :ensure t
  :bind (("C-c o" . crux-open-with)
         ("C-c n" . crux-cleanup-buffer-or-region)
         ("C-c f" . crux-recentf-find-file)
         ("C-c u" . crux-view-url)
         ("C-c w" . crux-swap-windows)
         ("C-c D" . crux-delete-file-and-buffer)
         ("C-c r" . crux-rename-buffer-and-file)
         ("C-c k" . crux-kill-other-buffers)
         ("C-c TAB" . crux-indent-rigidly-and-copy-to-clipboard)
         ("C-c I" . crux-find-user-init-file)
         ("C-<backspace>" . crux-kill-line-backwards)
         ("s-o" . crux-smart-open-line-above)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line)
         ([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line-above)
         ([remap kill-whole-line] . crux-kill-whole-line)
         ))

(use-package deadgrep
  :ensure t
  :config
  (global-set-key (kbd "C-c s") 'deadgrep))

(use-package ace-window
  :ensure t
  :config
  (global-set-key (kbd "M-o") 'ace-window))

;; Handy key chords
;; (use-package key-chord
;;   :ensure t
;;   :config
;;   (key-chord-define-global "[s" 'save-buffer)
;;   (key-chord-define-global "KK" 'kill-current-buffer))

(use-package company
  :ensure t)

(use-package typescript-mode
  :ensure t)

(use-package markdown-mode
  :ensure t)

(use-package editorconfig
  :ensure t)

;; ido
;; (ido-mode t)
;; (icomplete-mode t)
;; (ido-everywhere t)

;; auto-complete
(global-company-mode)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package avy
  :ensure t
  :bind (("s-." . avy-goto-word-or-subword-1)
         ("s-," . avy-goto-char)
         ("C-c ." . avy-goto-word-or-subword-1)
         ("C-c ," . avy-goto-char)
         ("M-g f" . avy-goto-line)
         ("M-g w" . avy-goto-word-or-subword-1))
  :config
  (setq avy-background t))

;; no backups
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq auto-save-list-file-name nil);; common
(global-set-key (kbd "<f1>") 'ibuffer)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(deadgrep editorconfig gnu-elpa-keyring-update ido-vertical-mode evil elpher key-chord zop-to-char zenburn-theme yaml-mode which-key web-mode volatile-highlights vertico utop use-package undo-tree super-save rust-mode rainbow-mode rainbow-delimiters pt projectile paredit orderless move-text merlin-eldoc markdown-mode marginalia magit keycast inf-ruby inf-clojure imenu-anywhere hl-todo haskell-mode git-timemachine gif-screencast flycheck-ocaml flycheck-joker flycheck-eldev expand-region exec-path-from-shell erlang elixir-mode elisp-slime-nav eglot easy-kill dune diminish diff-hl crux corfu consult company cider cask-mode anzu ag adoc-mode ace-window)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
