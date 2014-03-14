# bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# PATH configuration
export PATH=$HOME/bin:/usr/local/sbin:$PATH

eval "$(hub alias -s)" # (git)hub settings

# git prompt (depends on bash-completion)
export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[1;31m\]$(__git_ps1)\[\033[01;34m\] \$\[\033[00m\] '
source ~/.nvm/nvm.sh
source ~/perl5/perlbrew/etc/bashrc
source `brew --prefix`/etc/profile.d/z.sh

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
alias gru='git fetch origin && git reset --hard @{upstream}'
alias hgrep='history | grep'
alias ls='ls -G'
alias rs='vr "sudo ubic restart -f"'
alias rv='git remote -v'
alias st='git status'
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias deploy-staging='ssh ct "sudo -iu chef /home/chef/scripts/provision.sh staging"'
alias sls='vr "tail -f /var/log/www/{api,www}.log"'
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
# Generate git format string on the fly to get the right top level directory
_gen_format_string() {
    echo "<a href=\"https://github.com/Crowdtilt/`basename $(git rev-parse --show-toplevel)`/commit/%h\" style='font-family:\"Courier new\"; color:red; font-weight:bold; text-decoration:none'>%h</a> %s <span style=\"color:green\">(%cr)</span> <<span style=\"color:blue; font-weight:bold;\">%an</span>><br />"
}

# Generate the html output for this repo's deploy commits
_gen_html_output() {
    (
        cd $2
        git fetch upstream
        format=`_gen_format_string`
        output=`git log --no-merges upstream/master..upstream/dev --pretty=format:"$format" --abbrev-commit`
        if [ -n "$output" ]; then
            echo "<b style=\"font-size:16px;\">$3:</b><br /> <div class=\"anchor\"> <br />" >> $1
            echo $output >> $file
            echo "</div><br /><br />" >> $file
        fi
    )
}

gen_deploy_email () {
    if [ -z $1 ]; then
        echo "Usage: gen_deploy_email /path/to/crowdtilt/root"
        return 1
    fi

    file="/tmp/deploys.html"
    echo "<div style=\"font-family:sans-serif; font-size:13px;\">" > $file

    # Start format
    _gen_html_output "$file" "$1/crowdtilt-public-site" "Public Site"
    _gen_html_output "$file" "$1/crowdtilt-internal-api" "API"
    _gen_html_output "$file" "$1/crowdtilt-internal-admin-site" "Admin Site"

    echo "</div>" >> $file

    open $file
}

vr () {
    echo "Running $@ on vag"
    vagrant ssh srv2 -c "$@"
}
