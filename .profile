# bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# PATH configuration
export GOPATH=$HOME/go
export PATH=$HOME/bin:./node_modules/.bin:/usr/local/sbin:$GOPATH/bin:$PATH

export JAVA_HOME=/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home

# Language definitions
export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"

export LESS='R'

eval "$(hub alias -s)" # (git)hub settings

# git prompt (depends on bash-completion)
export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[1;31m\]$(__git_ps1)\[\033[01;34m\] \$\[\033[00m\] '
source ~/.nvm/nvm.sh
source ~/perl5/perlbrew/etc/bashrc
source `brew --prefix`/etc/profile.d/z.sh
source $HOME/.aws # Vagrant AWS Instance
source $HOME/Projects/ct/goodies/deploy-script.sh
alias deploys="gl --no-merges upstream/master..upstream/dev"
alias al='ssh -t -D 8383 pm tmux attach'
alias ct='cd ~/Projects/ct'
alias fm='vr "echo flush_all | nc localhost 11211"'
alias g='hub'
alias gca='git commit --amend --no-edit'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gd='git diff'
alias gdc='git diff --cached'
alias git='hub'
alias gl="git log --pretty=format:'%Cred%h%Creset - %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glo='git lol'
alias grph='git rev-parse HEAD'
alias gru='git fetch origin && git reset --hard @{upstream}'
alias hgrep='history | grep'
alias ls='ls -G'
alias rs='vr "sudo ubic restart -f"'
alias rsa='vr "sudo ubic restart -f starman_api"'
alias rsr='vr "sudo restart reify"'
alias rsw='vr "sudo ubic restart -f starman_www"'
alias rv='git remote -v'
alias st='git status'
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias deploy-staging='ssh ct "sudo -iu chef /home/chef/scripts/provision.sh staging"'
alias deploy-prod='ssh ct "sudo -iu chef /home/chef/scripts/provision.sh production"'
alias sla='vr "tail -f /var/log/www/api.log"'
alias sls='vr "tail -f /var/log/www/{www,api}.log"'
alias slw='vr "tail -f /var/log/www/www.log"'
alias vbr='sudo launchctl load /Library/LaunchDaemons/org.virtualbox.startup.plist'
alias vc="mvim -c 'call EditConflitedArgs()' \$(git diff --name-only --diff-filter=U)"

psg() {
    ps axu | grep -v grep | grep "$@" -i --color=auto;
}

pullreq() {
    HEAD=$(git symbolic-ref HEAD 2> /dev/null)
    CUR_BRANCH=${HEAD#refs/heads/}
    git push origin $CUR_BRANCH
    MSG=`git log -n1 --pretty=%s`
    hub pull-request -m "$MSG" -b Crowdtilt:dev -h $CUR_BRANCH
}

vr () {
    echo "Running $@ on vag"
    vagrant ssh srv2 -c "$@"
}
