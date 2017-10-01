

;;;;;; PYTHON
(package-initialize)
(elpy-enable)
;; Fixing a key binding bug in elpy
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
;; Fixing another key binding bug in iedit mode
(define-key global-map (kbd "C-c o") 'iedit-mode)
(setenv "PYTHONPATH" "/usr/bin/python")
;(add-hook 'python-mode-hook (setq flymake-mode nil))