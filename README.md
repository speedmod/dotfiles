# 自分用設定ファイル置き場

.emacsとか.bash_profileとかその辺

## 使い方 

```bash
$ cd
$ git clone https://github.com/speedmod/dotfiles.git
```

### bash

ホームディレクトリにシンボリックリンクを置く。

```bash
$ cd
$ ln -s dotfiles/bash/.bashrc .bashrc
$ ln -s dotfiles/bash/.bash_profile .bash_profile
$ ln -s dotfiles/bash/.bash_prompt .bash_prompt
```

ターミナル＞環境設定＞プロファイルから「Pro」をデフォルトとして選択
フォントはMonacoの14ptを設定。

### emacs

```bash
$ cd 
$ brew install cask
$ ln -s dotfiles/emacs/.emacs .emacs
$ cd .emacs.d
$ ln -s dotfiles/cask/Cask Cask
```

ここで.emacsの中のCaskの設定を修正する。

```emacs-lisp
;;
;; Cask
;;
(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize)
```

requireするcaskのelファイルのパスをインストール先に置き換える。

そのあと、

```bash
$ cask init
```

emacsを起動すると、elscreenあたりでエラーが出る可能性があるがその場合には適宜コメントアウトしてしまう。
elscreenはcaskで管理すればいいのです

