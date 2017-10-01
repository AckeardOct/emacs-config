


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

(set-default-font "Liberation Mono-10")

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

(global-set-key (kbd "<C-Tab>") 'other-window) ;; переключение окон

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