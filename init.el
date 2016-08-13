;;; package -- Summary
;;;
;;; Commentary:
;;; This is my init.el.  I put this here to make Flycheck shut up.

;;; Code:

;; MELPA
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(load-theme 'solarized-light t)

;; Start in fullscreen
(defun my-fullscreen-hook ()
  "A hook which gets called after window setup."
  (custom-set-variables
    '(initial-frame-alist (quote ((fullscreen . maximized)))))
  (set-frame-parameter nil 'fullscreen 'fullboth)
)

(add-hook 'window-setup-hook 'my-fullscreen-hook)

;; Use relative line numbers
(linum-relative-mode)
(setq linum-relative-current-symbol "")
(ruler-mode 1)

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(2 ((shift) . 5))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;; Undo tree
(undo-tree-mode)

;; Go setup
(defun my-go-mode-hook ()
  "Add this stuff to go-mode."
  ;; go-eldoc
  (go-eldoc-setup)
  ;; Use goimports instead of gofmt
  (setq gofmt-command "goimports")
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
         "go generate ./... && go test --coverprofile=cover.out ./... && go build ./..."))
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

(defun my-javascript-hook ()
  "My Javascript config hook."
  ;; TODO: FIXME!
  ; (flycheck-add-next-checker 'javascript 'gjslint 'javascript-flow)
)

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
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "cdbd0a803de328a4986659d799659939d13ec01da1f482d838b68038c1bb35e8" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
