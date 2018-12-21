# Add git branch if its present to PS1COLOR_RED="\033[0;31m"
#COLOR_YELLOW="\033[0;33m"
#COLOR_GREEN="\033[0;32m"
#COLOR_OCHRE="\033[38;5;95m"
#COLOR_BLUE="\033[0;34m"
#COLOR_WHITE="\033[0;37m"
#COLOR_RESET="\033[0m"
function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ $git_status =~ "nothing to commit, working tree clean" ]]; then
    echo -e "\033[0;32m"
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e "\033[0;33m"
  else
    echo -e "\033[0;31m"
  fi
}
function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch)"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit)"
  fi
}
parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;34m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[$(git_color)\]$(parse_git_branch)\[\033[00m\]\$ '
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
fi
unset color_prompt force_color_prompt
