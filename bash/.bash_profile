# Trigger ~/.bashrc commands
. ~/.bashrc
eval "$(rbenv init -)"

## Aliases
alias ls='ls -aFG'
alias ll='ls -l'
alias be='bundle exec'

## Functions
# MRブランチの変更ファイル一覧表示
# Usage: $ changes <devへのMRを出したブランチ名>
# ちなみにsed '$d'は、ラスト1行を削除する処理です。
changes () {
  branches=`git log --pretty=format:"%H %P %s" | grep "Merge branch '$1' into 'dev'" | awk '{print $1 " " $2}'`
  git diff --stat $branches | awk '{print $1}' | grep -v spec | sed '$d'
}

# テスト実行
sp () {
    bundle exec rake spec SPEC=$1
}

# リポジトリからブランチを取得し、そのブランチにチェックアウト
co () {
    echo "> git fetch origin $1"
    git fetch origin $1
    echo "> git branch $1 origin/$1"
    git branch $1 origin/$1
    echo "> git checkout $1"
    git checkout $1
}

# 英単語の用例を抽出
dic () {
    w3m "http://ejje.weblio.jp/content/$1" | grep "用例"
}

