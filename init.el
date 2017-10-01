;; ========== Автоустановка пакетов
(require 'cl) ;; common lisp
(require 'package) ;; пакетный менеджер

(defvar cfg-var:packages '(
    d-mode ;; подсветка Dlang
    ac-dcd ;; автодополнение Dlang
    nav    ;; навигация по файловой системе
    auto-complete ;; общее автодополнение
    flycheck ;; проверка синтаксиса
    autopair ;; авто скобки
    company
    company-dcd
    elpy
    web-mode
    php-mode
    projectile
    flymake-d
    flymake-php
    php-auto-yasnippets
    phpunit
    company-php
    company-web
    smartparens
    feature-mode
    tramp
    quickrun
    expand-region
    restclient
    ))

(defun cfg:install-packages ()
    (let ((pkgs (remove-if #'package-installed-p cfg-var:packages)))
        (when pkgs
            (message "%s" "Emacs refresh packages database...")
            (package-refresh-contents)
            (message "%s" " done.")
            (dolist (p cfg-var:packages)
                (package-install p)))))

(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)
(cfg:install-packages)

;; ========== Хоткеи на русской раскладке
    ;; должна быть еще строчка в конце файла
(defun cfg:reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (default current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key local-function-key-map
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))

;; ========== Theme
(load-file "~/.emacs.d/rc/theme.el")

;; ========== Common settings
(load-file "~/.emacs.d/rc/common.el") 

;; ========== Dlang
(load-file "~/.emacs.d/rc/dlang.el") 

;; ========== Python
(load-file "~/.emacs.d/rc/python.el") 

;; ========== Web
(load-file "~/.emacs.d/rc/web.el") 

;; ========== Хоткеи на русской раскладке
;; А вот эта строка должна быть в самом конце
(cfg:reverse-input-method 'russian-computer)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (wombat)))
 '(package-selected-packages
   (quote
    (elpy company-jedi company-dcd company autopair flycheck auto-complete nav d-mode ac-dcd))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
