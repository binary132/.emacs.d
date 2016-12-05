;;; package -- Summary
;;;
;;; Commentary:
;;; This is my init.el.  I put this here to make Flycheck shut up.

;;; Code:

;; MELPA
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(load-theme 'sanityinc-tomorrow-day t)

;; Start in fullscreen
(defun my-fullscreen-hook ()
  "A hook which gets called after window setup."
  (custom-set-variables
    '(initial-frame-alist (quote ((fullscreen . maximized)))))
  (set-frame-parameter nil 'fullscreen 'fullboth)
  (tool-bar-mode -1)
)

(add-hook 'window-setup-hook 'my-fullscreen-hook)

;; Use whitespace mode to highlight lines extending beyond 72 columns.
(setq whitespace-line-column 72)
(setq whitespace-style '(face empty lines-tail trailing))
(global-whitespace-mode t)

;; Use relative line numbers
(linum-relative-mode)
(setq linum-relative-current-symbol "")
(ruler-mode 1)

;; Set up fonts.
(set-face-attribute 'default nil
		    :foundry "apple"
		    :family  "Go Mono"
		    :height  130
		    :weight  'light)

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(2 ((shift) . 5))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;; Undo tree
(undo-tree-mode)

(setq-default indent-tabs-mode nil)

;; Go setup
(defun my-go-mode-hook ()
  "Add this stuff to go-mode."
  ;; go-eldoc
  (go-eldoc-setup)
  ;; Use goimports instead of gofmt
  (setq gofmt-command "goimports")
  ;; Use smart tabs
  (setq indent-tabs-mode t)
  ;; gofmt-before-save
  (add-hook 'before-save-hook 'gofmt-before-save)
  ;; Go Guru identifier highlighting
  (add-hook 'go-mode-hook #'go-guru-hl-identifier-mode)
  ;; Godef jump / return hotkeys
  (local-set-key (kbd "C-x ,") 'godef-jump)
  (local-set-key (kbd "<s-mouse-1>") 'godef-jump)
  (local-set-key (kbd "C-x /") 'pop-tag-mark)
  ;; Use company-go
  (setq company-backends '(company-go))
  (company-mode)
  ;; linum-relative-mode
  (linum-relative-mode)
  (setq linum-relative-current-symbol "")
  ;; RaTS -- run tests from Go files
  (rats-mode)
  ;; Compile and test
  (if (not (string-match "go" compile-command))
    (set (make-local-variable 'compile-command)
         (concat "go generate ./... && "
		 "go test --coverprofile=cover.out . && "
		 "go build ./...")))
  (local-set-key (kbd "C-x c") 'compile)
  ;; Ruler mode
  (ruler-mode 1)
  ;; Undo tree
  (undo-tree-mode)
)

;; Bind my Go setup to go-mode-hook
(add-hook 'go-mode-hook 'my-go-mode-hook)

;; Bind rainbow-delimiters to elisp mode
(defun my-elisp-hook ()
  "My Emacs Lisp config hook."
  (rainbow-delimiters-mode)
)

(add-hook 'emacs-lisp-mode-hook 'my-elisp-hook)

;; Javascript stuff
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(defun my-vue-mode-hook ()
  "My vue-mode config hook."
  (linum-relative-mode)
  (setq linum-relative-current-symbol "")

  (ruler-mode 1)
  (undo-tree-mode)
)

(defun my-js2-hook ()
  "My js2-mode config hook."
  (setq js-indent-level 2)

  (setq company-backends '(company-tern))
  (company-mode)

  (linum-relative-mode)
  (setq linum-relative-current-symbol "")

  (ruler-mode 1)
  (undo-tree-mode)

  (add-hook 'after-save-hook 'eslint-fix nil t)
  ;; TODO: FIXME!
  ; (flycheck-add-next-checker 'javascript 'gjslint 'javascript-flow)
)

(add-hook 'vue-mode-hook 'my-vue-mode-hook)
(add-hook 'js2-mode-hook 'my-js2-hook)

(defun my-elixir-mode-hook ()
  "My Elixir hook."
  (smartparens-mode)
  (sp-with-modes '(elixir-mode)
    (sp-local-pair "fn" "end"
           :when '(("SPC" "RET"))
           :actions '(insert navigate))
    (sp-local-pair "do" "end"
           :when '(("SPC" "RET"))
           :post-handlers '(sp-ruby-def-post-handler)
           :actions '(insert navigate))
  )
)

(add-hook 'elixir-mode 'my-elixir-mode-hook)

(defun my-rust-mode-hook ()
  "My Rust-mode hook."
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
  (setq indent-tabs-mode t)
  (setq racer-rust-src-path (getenv "RUST_SRC_PATH"))
  (setq racer-cmd (concat (getenv "HOME") "/.cargo/bin/racer"))
  (racer-mode)
  (eldoc-mode)
  (company-mode)
)

(add-hook 'rust-mode-hook 'my-rust-mode-hook)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(add-hook 'irony-mode-hook 'irony-eldoc)
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

(defun my-cxx-mode ()
  "My C / C++ config hook."
  (cmake-ide-setup)
  (setq indent-tabs-mode t)
  (add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
  (add-to-list 'company-backends '(company-irony-c-headers
				   company-irony))
  (c-set-style "K&R")
  ;; linum-relative-mode
  (linum-relative-mode)
  (setq linum-relative-current-symbol "")
  (irony-mode)
  ;; autocomplete
  (company-mode)
)

(defun my-flycheck-rtags-setup ()
  "Set up Flycheck to use RTags overlays."
  (flycheck-select-checker 'rtags)
  ; RTags creates more accurate overlays.
  (setq-local flycheck-highlighting-mode nil)
  (setq-local flycheck-check-syntax-automatically nil)
)

;; c-mode-common-hook is also called by c++-mode
;(add-hook 'my-cxx-mode #'my-flycheck-rtags-setup)

(add-hook 'c++-mode-hook 'my-cxx-mode)
(add-hook 'c-mode-hook 'my-cxx-mode)

;; Global Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

(provide 'init)
;;; init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "cdbd0a803de328a4986659d799659939d13ec01da1f482d838b68038c1bb35e8" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(js2-bounce-indent-p t)
 '(js2-concat-multiline-strings (quote eol))
 '(js2-strict-missing-semi-warning nil)
 '(package-selected-packages
   (quote
    (eslint-fix company-tern color-theme-sanityinc-tomorrow zenburn-theme vue-mode undo-tree solarized-theme rats rainbow-delimiters racer mocha markdown-mode magit linum-relative goto-last-change go-rename go-guru go-eldoc go-dlv go-direx flycheck-rust flycheck-gometalinter flycheck-flow company-go cargo ack))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-error ((t (:underline "#c82829"))))
 '(js2-warning ((t (:underline (:color "gold" :style wave))))))
