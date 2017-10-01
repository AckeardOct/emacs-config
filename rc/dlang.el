

;; ========== D-MODE
(require 'd-mode)
(add-to-list 'auto-mode-alist '("\\.d\\'" . d-mode))

(defun rdmd() ;; запуск rdmd для текущего файла
  "Run rdmd for current file.d with unittests"
  (interactive)
  
  (setq rdmd-cmd (concat "rdmd -unittest " buffer-file-name))
  (save-buffer)
  (async-shell-command rdmd-cmd)
  )

(defun dub() ;; запуск dub для текущего проекта
  "Run dub for current project" ;; от ткущего файла спускается в низ по директориям 
  (interactive)                 ;; пока не найдёт dub.json,
  (save-buffer)                 ;; но не дальше 6ти директорий
  (setq str "./")
  (while (eq (file-exists-p (concat str "dub.json")) (eq str "./../../../../../../"))
    (setq str(concat str "../")))
  (setq str (concat "cd " str " && dub"))
  (async-shell-command str)
)

(define-key d-mode-map (kbd "<f6>") 'rdmd) ;; привязка клавиш к функциям
(define-key d-mode-map (kbd "<f5>") 'dub)  ;; rdmd и dub

;; отключаем вопросы при выходе по поводу запущенного dcd-server
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (cl-letf (((symbol-function #'process-list) (lambda ())))
    ad-do-it))

;; ========== ac-dcd
(require 'ac-dcd)
(add-hook 'd-mode-hook
  (lambda ()
      (auto-complete-mode t)
      (when (featurep 'yasnippet) (yas-minor-mode-on))
      (ac-dcd-maybe-start-server)
      (ac-dcd-add-imports)
      (autopair-mode t)
      (ac-dcd--find-all-project-imports)
      (add-to-list 'ac-sources 'ac-source-dcd)
      (define-key d-mode-map (kbd "C-c ?") 'ac-dcd-show-ddoc-with-buffer)
      (define-key d-mode-map (kbd "C-c .") 'ac-dcd-goto-definition)
      (define-key d-mode-map (kbd "C-c ,") 'ac-dcd-goto-def-pop-marker)
      (define-key d-mode-map (kbd "C-c s") 'ac-dcd-search-symbol)          
	  
      (when (featurep 'popwin)
          (add-to-list 'popwin:special-display-config
                     `(,ac-dcd-error-buffer-name :noselect t))
          (add-to-list 'popwin:special-display-config
                     `(,ac-dcd-document-buffer-name :position right :width 80))
          (add-to-list 'popwin:special-display-config
                     `(,ac-dcd-search-symbol-buffer-name :position bottom width 5)))))

;; ========== company-dcd
;(require 'company-dcd)
;(add-hook 'd-mode-hook 'company-dcd-mode)

;; ========== Отступы
(setq-default indent-tabs-mode nil) ; не использовать символ Tab для отсутпа

(setq tab-width 4 ; ширина таба
      c-default-style "stroustrup" ; отступ в CC mode
      js-indent-level 4 ; indentation level in JS mode
      css-indent-offset 4) ; indentation level in CSS mode

(add-hook 'd-mode-hook
          (lambda ()
            (setq tab-wdth 4)
            ))

(add-hook 'text-mode-hook
          (lambda ()
            (setq tab-wdth 4)
            ))

(global-set-key (kbd "TAB") 'self-insert-command) ;; indent
(setq-default c-basic-offset 4) 
(setq-default tab-width 4)