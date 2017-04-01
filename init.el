
;; ========== Автоустановка пакетов
(require 'cl) ;; ???
(require 'package) ;; ???

(defvar cfg-var:packages '(
    d-mode ;; подсветка Dlang
	ac-dcd ;; автодополнение Dlang
    nav    ;; навигация по файловой системе
    auto-complete ;; общее автодополнение
    flycheck ;; проверка синтаксиса
    autopair ;; авто скобки
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


;; ========== Цветовая схема
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (wombat))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

 ;; ========== Общие нестройки
(server-start) ;; запуск в режиме сервера
(cua-mode t) ;; работа с буфером обмена по человечески
(defalias 'yes-or-no-p 'y-or-n-p) ;; укорачиваем вопросы

;(set user-full-name "Ackeard Oct") ;; привязываем личность
;(set user-mail-address "AckeardOct@yandex.ru")

(setq inhibit-splash-screen t) ;; прячем экран приветсвия
(setq inhibit-startup-message t) ;; его можно вызвать C-h C-a

(show-paren-mode t) ;; выделяем выражения в скобках
(setq show-paren-style 'expression) ;; выделяем цветом

(delete-selection-mode t) ;; удаляем выделенный текст, когда пишем поверх

(setq make-backup-files nil) ;; отключаем автоматические сохранения
(setq auto-save-default nil)
(setq auto-save-list-file-name nil)

(require 'linum) ;; модуль нумерации строк
(line-number-mode t) ;; показывает номер строки в mode-line
(global-linum-mode t) ;; номера строк во всех буферах
(column-number-mode t) ;; показывать номер столбца в mode-line
(setq linum-format "%d") ;; задаём формат нумерации строк

;(fringe-mode '(8.0)) ;; ограничитель текста только слева
(setq-default indicate-empty-lines t) ;; отсутсвие строки выделить глифами рядом с полоской с номером строки
(setq-default indicate-buffer-boundaries 'left) ;; индикация только слева

(setq visible-bell t) ;; отключаем писк при ошибках. Вместо этого мигает в строке статуса

;(set-face-attribute 'default nil :font "Terminus-12")

(tool-bar-mode -1) ;; отключаем лишние панели
(menu-bar-mode -1)
(scroll-bar-mode -1)

(iswitchb-mode 1) ;; интерактивный режим переключения буферов 

(setq word-wrap t) ;; автоперенос по словам
(global-visual-line-mode t)

(require 'ido) ;; интерактивный режим открытия файлов
(ido-mode t)
(icomplete-mode t)
(ido-everywhere t)
(setq ido-virtual-buffers t)
(setq ido-enable-flex-matching t)

(require 'bs) ;; быстрая навигация между буферами
(require 'ibuffer)
(defalias 'list-buffers 'ibuffers) ;; отдельный список буферов C-x C-b
(global-set-key (kbd "<f2>") 'bs-show) ;; запуск buffer-selection по F2

(setq scroll-step 1) ;; скролинг по 1 строке
(setq scroll-margin 10) ;; сдвигать вверх вниз когда курсор в 10 строках
;(setq scroll-conservatively 10000) ;; ???

(setq x-select-enable-clipboard t) ;; общий буфер обмена с ОС

(setq search-highlight t) ;; Выделять результаты поиска
(setq query-replace-highlight t)

;; запилить закладки

;; ========== NAV
(require 'nav)
(nav-disable-overeager-window-splitting)
(global-set-key (kbd "<f8>") 'nav-toggle)

(defun nav-mode-hl-hook ()
  (local-set-key (kbd "<right>") 'nav-open-file-under-cursor)
  (local-set-key (kbd "<left>")  'nav-go-up-one-dir))

(add-hook 'nav-mode-hook 'nav-mode-hl-hook)

;; ========== autopair-mode
(require 'autopair) ;; автовставка скобок
(autopair-mode t)

;; ========== D-MODE
(require 'd-mode)
(add-to-list 'auto-mode-alist '("\\.d\\'" . d-mode))

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
                         `(,ac-dcd-search-symbol-buffer-name :position bottom :width 5)))))

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

;; ========== Хоткеи на русской раскладке
;; А вот эта строка должна быть в самом конце
(cfg:reverse-input-method 'russian-computer)
