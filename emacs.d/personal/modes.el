;; Javascript mode
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; Ruby hooks
(add-hook 'ruby-mode-hook (lambda ()
                            ;; ri support
                            (setq ri-ruby-script
                                  (concat emacs-root "/.emacs.d/modes/ruby/ri-emacs.rb"))
                            (autoload 'ri
                              "~/.emacs.d/modes/ruby/ri-ruby.el" nil t)
                            (local-set-key [f1] 'ri)
                            (local-set-key [f4] 'ri-ruby-show-args)
                            ;; Rcodetools
                            (require 'rcodetools)
                            (local-set-key "\M-\C-i" 'rct-complete-symbol)
                            (local-set-key [f2] 'xmp)
                            ;; Autotest
                            (if (not (eq window-system nil))
                                (progn
				  (require 'unit-test)
				  (require 'autotest)
				  (setq autotest-use-ui t)))))

;; Improved compile mode
(autoload 'mode-compile "mode-compile"
  "Command to compile current buffer file based on the major mode" t)
(global-set-key "\C-cc" 'mode-compile)
(autoload 'mode-compile-kill "mode-compile"
  "Command to kill a compilation launched by `mode-compile'" t)
(global-set-key "\C-ck" 'mode-compile-kill)


;; Make the window transparent in Mac OS X when not running from a
;; terminal requires Carbon Emacs
(if (and (eq system-type 'darwin)
         (eq window-system 'mac))
    (set-frame-parameter nil 'alpha 95))


;; The snippets support just make it global - snippets are great when
;; they can be used!
(require 'yasnippet)
(yas/initialize)
(yas/load-directory (concat emacs-root ".emacs.d/snippet/snippets/"))
(yas/load-directory (concat emacs-root ".emacs.d/snippet/my-snippets/"))
