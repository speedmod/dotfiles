# Trigger ~/.bashrc commands
. ~/.bashrc
eval "$(rbenv init -)"

## Aliases
alias ls='ls -aF'
alias ll='ls -l'
alias be='bundle exec'

## Functions
# テスト実行
sp () {
    bundle exec rake spec SPEC=$1
}

# リポジトリからブランチを取得
co () {
    git fetch origin $1
    git branch $1 origin/$1
}

# 英単語の用例を抽出
dic () {
    w3m "http://ejje.weblio.jp/content/$1" | grep "用例"
}

