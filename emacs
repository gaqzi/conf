;; The home directory
(defvar emacs-root (if (eq system-type 'darwin)
                       "/Users/ba/"
                     (if (eq system-type 'gnu/linux)
                         "/home/ba/")))
(cd emacs-root) ; Start emacs from my home and nowhere else!
;; M-x with C-x C-m
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
;; C-w backward kill word
(global-set-key "\C-w"     'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)
;; Rerun keyboard macro on F5
(global-set-key [f5]       'call-last-kbd-macro)
(global-set-key "\M-/"     'hippie-expand)

;; Loose the UI
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; lots of perrty colors!
(defconst font-lock-maximum-decoration t)

;; Show the columnposition of point in the status bar
(column-number-mode 1)
(line-number-mode 1)
(blink-cursor-mode nil)

;; Yes is long, prefer y
(fset 'yes-or-no-p 'y-or-n-p)

;; Some backup sanity, put it in ~/tmp and keep a revision of them
(setq backup-by-copying t)
(add-to-list 'backup-directory-alist (cons "." (concat emacs-root "tmp/")))
(setq delete-old-versions t)
(setq kept-new-versions 6)
(setq kept-old-versions 2)
(setq version-control t)
(setq indent-tabs-mode nil)
;; No startup message
(setq inhibit-startup-message t)
;; Comment empty lines when commenting a region
(setq comment-empty-lines t)
;; Show matching parens
(show-paren-mode t)
;; Automatic abbrevation expand!
;(setq default-abbrev-mode t)

;; Save hooks
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'after-save-hook  'executable-make-buffer-file-executable-if-script-p)

;; Interactive DO - buffers autocomplete <3
(require 'ido)
(ido-mode t)

;; Set default encoding UTF-8
(setq set-language-environment "UTF-8")
(setq locale-coding-system      'utf-8)
(set-terminal-coding-system     'utf-8)
(set-keyboard-coding-system     'utf-8)
(set-selection-coding-system    'utf-8)
(prefer-coding-system           'utf-8)

;; add all the elisp directories under ~/.emacs.d to my load path
(defun ba-add-path (p)
  (add-to-list 'load-path
      (concat emacs-root p)))
;(labels ((add-path (p)
;		   (add-to-list 'load-path
;				(concat emacs-root p))))
(ba-add-path ".emacs.d/personal")    ;; My own configuration and stuff
(ba-add-path ".emacs.d/color-theme")
(ba-add-path ".emacs.d/ruby")
(ba-add-path ".emacs.d/snippet/")
(ba-add-path ".emacs.d/testing")
(ba-add-path ".emacs.d/modes")
;  )

(load-library "modes") ;; configuration for modes

;; Make it nice with a custom color-theme!
(require 'color-theme)
(color-theme-initialize)
(color-theme-ld-dark)

(setq Info-directory-list (append '("~/.emacs.d/info")
				  Info-default-directory-list))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(autotest-use-ui t))

