;;
;; Cask
;;
(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
;; ~/.emacs.d/.cask/24.4.1/elpa/cask-20141109.309/cask.el")
(cask-initialize)

;;
;; ElScreen
;;
(elscreen-start)

;;
;; Emacs -> Options -> Customize Emacs
;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (deeper-blue))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; 対応する括弧を光らせる
(show-paren-mode 1)

;; 列番号表示
(column-number-mode t)

;; 起動時のメッセージを消す
(setq inhibit-startup-message t)

;; スクラッチのメッセージを消す
(setq initial-scratch-message "")

;; @see http://d.hatena.ne.jp/kazu-yamamoto/20140625/1403674172
;; Mac 用のフォント設定
(when (memq window-system '(mac ns))
  (global-set-key [s-mouse-1] 'browse-url-at-mouse)
  (let* ((size 14)
	 (jpfont "Hiragino Kaku Gothic ProN") ;; Maru Gothicもあるよ
	 (asciifont "Monaco")
	 (h (* size 10)))
    (set-face-attribute 'default nil :family asciifont :height h)
    (set-fontset-font t 'katakana-jisx0201 jpfont)
    (set-fontset-font t 'japanese-jisx0208 jpfont)
    (set-fontset-font t 'japanese-jisx0212 jpfont)
    (set-fontset-font t 'japanese-jisx0213-1 jpfont)
    (set-fontset-font t 'japanese-jisx0213-2 jpfont)
    (set-fontset-font t '(#x0080 . #x024F) asciifont))
  (setq face-font-rescale-alist
	'(("^-apple-hiragino.*" . 1.2)
	  (".*-Hiragino Maru Gothic ProN-.*" . 1.2)
	  (".*osaka-bold.*" . 1.2)
	  (".*osaka-medium.*" . 1.2)
	  (".*courier-bold-.*-mac-roman" . 1.0)
	  (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
	  (".*monaco-bold-.*-mac-roman" . 0.9)
	  ("-cdac$" . 1.3)))
  ;; C-x 5 2 で新しいフレームを作ったときに同じフォントを使う
  (setq frame-inherited-parameters '(font tool-bar-lines)))

;; Thanks to http://www.cozmixng.org/~kou/emacs/dot_emacs

;; ツールバーを消す
(tool-bar-mode 0)

;; スクロールを指定数字の行数ごとにする
(setq scroll-step 1)

;; トラックパッドでのスクロール速度を控えめに
(defun scroll-down-with-lines ()
  "" (interactive) (scroll-down 3))
(defun scroll-up-with-lines ()
  "" (interactive) (scroll-up 3))
(global-set-key [wheel-up] 'scroll-down-with-lines)
(global-set-key [wheel-down] 'scroll-up-with-lines)
(global-set-key [double-wheel-up] 'scroll-down-with-lines)
(global-set-key [double-wheel-down] 'scroll-up-with-lines)
(global-set-key [triple-wheel-up] 'scroll-down-with-lines)
(global-set-key [triple-wheel-down] 'scroll-up-with-lines)

;; 行番号
(global-linum-mode t)

;; Emacs equivalents of Vim's dd, o, O
;; @see http://stackoverflow.com/questions/2173324/emacs-equivalents-of-vims-dd-o-o
;; Vim's O
(defun vi-open-line-above ()
  "Insert a newline above the current line and put point at beginning."
  (interactive)
  (unless (bolp)
    (beginning-of-line))
  (newline)
  (forward-line -1)
  (indent-according-to-mode))

;; Vim's o
(defun vi-open-line-below ()
  "Insert a newline below the current line and put point at beginning."
  (interactive)
  (unless (eolp)
    (end-of-line))
  (newline-and-indent))

(defun vi-open-line (&optional abovep)
  "Insert a newline below the current line and put point at beginning.
With a prefix argument, insert a newline above the current line."
  (interactive "P")
  (if abovep
      (vi-open-line-above)
    (vi-open-line-below)))

;; Vim's dd
(defun kill-current-line (&optional n)
  (interactive "p")
  (save-excursion
    (beginning-of-line)
    (let ((kill-whole-line t))
      (kill-line n))))

;; @see http://www.emacswiki.org/emacs/IndentingText
;; Shift the selected region right if distance is postive, left if
;; negative

(defun shift-region (distance)
  (let ((mark (mark)))
    (save-excursion
      (indent-rigidly (region-beginning) (region-end) distance)
      (push-mark mark t t)
      ;; Tell the command loop not to deactivate the mark
      ;; for transient mark mode
      (setq deactivate-mark nil))))

(defun shift-right ()
  (interactive)
  (shift-region 1))

(defun shift-left ()
  (interactive)
  (shift-region -1))

;; 縦分割と横分割のトグル
;; cf. http://www.bookshelf.jp/soft/meadow_30.html#SEC404
(defun window-toggle-division ()
  "ウィンドウ 2 分割時に、縦分割<->横分割"
  (interactive)
  (unless (= (count-windows 1) 2)
    (error "ウィンドウが 2 分割されていません。"))
  (let (before-height (other-buf (window-buffer (next-window))))
    (setq before-height (window-height))
    (delete-other-windows)

    (if (= (window-height) before-height)
        (split-window-vertically)
      (split-window-horizontally)
      )

    (switch-to-buffer-other-window other-buf)
    (other-window -1)))

;; Bind (shift-right) and (shift-left) function to your favorite keys. I use
;; the following so that Ctrl-Shift-Right Arrow moves selected text one
;; column to the right, Ctrl-Shift-Left Arrow moves selected text one
;; column to the left:

;(global-set-key [C-S-right] 'shift-right)
;(global-set-key [C-S-left] 'shift-left)

;;
;; キーバインド
;;
(define-key global-map (kbd "C-5") 'shift-right) ; Shift right
(define-key global-map (kbd "C-4") 'shift-left)  ; Shift left
(define-key global-map (kbd "C-o") 'vi-open-line-below)   ; Vim's o
(define-key global-map (kbd "C-@") 'vi-open-line-above)   ; Vim's O
(define-key global-map (kbd "C-S-k") 'kill-current-line)  ; Vim's dd
(define-key global-map (kbd "C-h") 'delete-backward-char) ; Backspace
(define-key global-map (kbd "M-C-h") 'help-for-help)      ; ヘルプ
(define-key global-map (kbd "C-c C-i") 'indent-region)    ; インデント
;(define-key global-map (kbd "C-c C-i") 'hippie-expand)   ; 補完
;(define-key global-map (kbd "C-c C-;") 'comment-dwim)    ; コメントアウト?
(define-key global-map (kbd "C-7") 'comment-region)       ; 範囲コメントアウト
(define-key global-map (kbd "C-8") 'uncomment-region)     ; 範囲アンコメント
(define-key global-map (kbd "M-C-g") 'grep)               ; grep
(define-key global-map (kbd "M-C-l") 'goto-line)          ; 指定行へ移動
;; キーバインド of elscreen
(define-key global-map (kbd "C-^") 'elscreen-next)     ; 次スクリーン
(define-key global-map (kbd "C-~") 'elscreen-previous) ; 前スクリーン

;; 上にスクロール
(define-key global-map (kbd "C-u") 'scroll-down)
;; 次のウィンドウへ移動
(define-key global-map (kbd "C-t") 'next-multiframe-window)
;; 前のウィンドウへ移動
(define-key global-map (kbd "C-S-t") 'previous-multiframe-window)
;; 上下二分割(C-x 2)
(define-key global-map (kbd "C-:") 'split-window-vertically)
;; 左右二分割(C-x 3)
(define-key global-map (kbd "C-. C-.") 'split-window-horizontally)
;; ウィンドウの削除
(define-key global-map (kbd "C-0") 'delete-window)
;; 縦分割と横分割のトグル
(define-key global-map (kbd "<f5>") 'window-toggle-division)
;; 新規フレーム（C-x 5 2はそもそも謎コマンドだし、日本語がonだとウザいので）
(define-key global-map (kbd "C-S-f") 'make-frame)
;; バッファ移動（C-x bだと、日本語がonだとウザいので）
(define-key global-map (kbd "C-S-b") 'switch-to-buffer)
;; ruby-modeへの設定追加
(setq ruby-insert-encoding-magic-comment nil)

;; 【Mac】特殊キーバインド対応
;; @see http://moya-notes.blogspot.jp/2013/02/emacs24-config-on-mac.html
;; 逆に￥の小文字が入力できない
(define-key global-map [?¥] [?\\])

;;
(setq markdown-command "/bin/sh /usr/local/bin/markdown")

;; whitespace-modeの設定
;; @see http://qiita.com/itiut@github/items/4d74da2412a29ef59c3a
(require 'whitespace)
(setq whitespace-style '(face           ; faceで可視化
                         trailing       ; 行末
                         tabs           ; タブ
                         spaces         ; スペース
                         empty          ; 先頭/末尾の空行
                         space-mark     ; 表示のマッピング
                         tab-mark
                         ))

(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        ;; WARNING: the mapping below has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        ;; If this is a problem for you, please, comment the line below.
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))

;; スペースは全角のみを可視化
(setq whitespace-space-regexp "\\(\u3000+\\)")

;; 保存前に自動でクリーンアップ
(setq whitespace-action '(auto-cleanup))

(global-whitespace-mode 1)

(defvar my/bg-color "#232323")
(set-face-attribute 'whitespace-trailing nil
                    :background my/bg-color
                    :foreground "DeepPink"
                    :underline t)
(set-face-attribute 'whitespace-tab nil
                    :background my/bg-color
                    :foreground "LightSkyBlue"
                    :underline t)
(set-face-attribute 'whitespace-space nil
                    :background my/bg-color
                    :foreground "GreenYellow"
                    :weight 'bold)
(set-face-attribute 'whitespace-empty nil
                    :background my/bg-color)

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-jsx-mode))
