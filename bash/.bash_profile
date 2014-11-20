# Trigger ~/.bashrc commands
. ~/.bashrc
eval "$(rbenv init -)"

# Aliases
alias ls='ls -aF'
alias ll='ls -l'
alias be='bundle exec'

# Functions
sp () {
  bundle exec rake spec SPEC=$1
}

dic () {
  w3m "http://ejje.weblio.jp/content/$1" | grep "用例"
}
