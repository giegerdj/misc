alias whios="whois"
alias ll='ls -alh'

alias gs='clear;git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias ga='git add'
alias gr='git rm'
alias gc='git checkout'
alias gm='git merge'


alias vu='(cd ~/repos/Homestead; vagrant up)'
alias vs='(cd ~/repos/Homestead; vagrant ssh)'
alias vh='(cd ~/repos/Homestead; vagrant halt)'

_complete_ssh_hosts ()
{
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts | \
                        cut -f 1 -d ' ' | \
                        sed -e s/,.*//g | \
                        grep -v ^# | \
                        uniq | \
                        grep -v "\[" ;
                cat ~/.ssh/config | \
                        grep "^Host " | \
                        awk '{print $2}'
                `
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
}
complete -F _complete_ssh_hosts ssh

