# bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# cruft
export PATH=$HOME/bin:$PATH

# git prompt (depends on bash-completion)
export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[1;31m\]$(__git_ps1)\[\033[01;34m\] \$\[\033[00m\] '
source ~/.nvm/nvm.sh
source ~/perl5/perlbrew/etc/bashrc
source `brew --prefix`/etc/profile.d/z.sh

alias al='ssh -t -D 8383 pm tmux attach'
alias ct='cd ~/Projects/ct'
alias gca='git commit --amend --no-edit'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log'
alias gru='git fetch origin && git reset --hard @{upstream}'
alias hgrep='history | grep'
alias ls='ls -G'
alias st='git status'
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias deploy-staging='ssh ct "sudo -iu chef /home/chef/scripts/provision.sh staging"'
alias sls='vagrant ssh srv1 -c "tail -f /var/log/www/{api,www}.log"'

psg() {
    ps axu | grep -v grep | grep "$@" -i --color=auto;
}

pullreq() {
    [ -z $BRANCH ] && BRANCH="dev"
    HEAD=$(git symbolic-ref HEAD 2> /dev/null)
    [ -z $HEAD ] && return # Return if no head
    MSG=`git log -n1 --pretty=%s`
    CUR_BRANCH=${HEAD#refs/heads/}

    if [[ "$CUR_BRANCH" == "dev" || "$CUR_BRANCH" == "master" ]]; then
        echo "You can't push directly to $CUR_BRANCH, thicky"
        return
    fi
    git push origin $CUR_BRANCH
    hub pull-request -b $BRANCH -h Crowdtilt:$CUR_BRANCH
}

#Git ProTip - Delete all local branches that have been merged into HEAD
git_purge_local_branches() {
    set -x
    BRANCHES=`git branch --merged | grep -v '^*' | grep -v 'master' | grep -v 'dev' | tr -d '\n'`
    echo "Running: git branch -d $BRANCHES"
    git branch -d $BRANCHES
    set +x
}

test_foo() {
    echo "$@"
}