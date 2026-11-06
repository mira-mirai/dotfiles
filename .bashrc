# ~/.bashrc: shared by all machines (macOS and linux)

# PATH comes first and runs for every shell, including non-interactive ones
# (`ssh host cmd`, scp, rsync), so tools in ~/.local/bin etc. are found there too
source ~/.path

# everything below is only for interactive shells. stopping here also keeps
# scp/rsync working: they break if .bashrc prints anything
case $- in *i*) ;; *) return ;; esac

echo "loading ~/.bashrc and ~/.path"

# linux: fedora/rhel expect ~/.bashrc to load the system bashrc. debian/ubuntu load
# /etc/bash.bashrc on their own, and macOS loads /etc/bashrc via /etc/profile
case $OSTYPE in
  linux*) [ -f /etc/bashrc ] && source /etc/bashrc ;;
esac

# tab completion (git branches, ssh hosts, etc.) if bash-completion is installed.
# homebrew's `bash-completion@2` needs bash 4.2+ (its loader checks); on macOS's bash 3.2
# only the older `bash-completion` package works
if [ -z "${BASH_COMPLETION_VERSINFO-}" ] && [ -z "${BASH_COMPLETION-}" ]; then
  for f in /usr/share/bash-completion/bash_completion /etc/bash_completion \
           "${HOMEBREW_PREFIX:-/nonexistent}/etc/profile.d/bash_completion.sh" \
           "${HOMEBREW_PREFIX:-/nonexistent}/etc/bash_completion"; do
    if [ -r "$f" ]; then source "$f"; break; fi
  done
fi

# git completion on its own, for machines without bash-completion (e.g. a mac using apple's git)
if ! complete -p git &>/dev/null; then
  for f in "${HOMEBREW_PREFIX:-/nonexistent}/etc/bash_completion.d/git-completion.bash" \
           /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash \
           /usr/share/bash-completion/completions/git; do
    if [ -r "$f" ]; then source "$f"; break; fi
  done
fi
unset f

# keep $LINES/$COLUMNS right after resizing the window
shopt -s checkwinsize

# history: one shared ~/.bash_history on every machine
# (on macOS, setup.sh also turns off Terminal.app's separate per-tab histories)
HISTSIZE=50000                # commands kept in memory
HISTFILESIZE=100000           # commands kept in ~/.bash_history
HISTCONTROL=ignoreboth        # skip repeated commands and ones starting with a space
HISTTIMEFORMAT='%F %T  '      # show when each command ran in `history`
shopt -s histappend           # add to the history file instead of overwriting it
# save each command as soon as it runs, so a crash or a still-open tab doesn't lose it.
# keeps any existing PROMPT_COMMAND (e.g. Terminal.app's current-folder tracking)
case "${PROMPT_COMMAND-}" in
  *"history -a"*) ;;
  *) PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
esac

# editor for git commit, crontab -e, etc. (minimal servers may only have vi)
if command -v vim >/dev/null; then
  export EDITOR=vim VISUAL=vim
else
  export EDITOR=vi VISUAL=vi
fi

# optional: let cd fix small typos (`cd Documnets` -> Documents). off for now
# shopt -s cdspell

# bash 4+ only (linux, and macOS with homebrew's bash). macOS's /bin/bash 3.2 skips these
if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
  # `**` matches any depth of folders: `ls **/*.md`
  shopt -s globstar
  # optional: type a folder name to cd into it. off for now
  # shopt -s autocd
fi

# linux: let `less` open archives and other non-text files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# lets keep aliases in their own file
echo "loading ~/.aliases"
source ~/.aliases

# prompt: blank line, then full path (blue) + git branch (yellow) + user@host,
# with commands typed on their own line below.
# user@host is dim on the machine in front of you and bold bright magenta over ssh,
# so it's obvious when you're on a server
__git_branch() { git symbolic-ref --short HEAD 2>/dev/null | sed 's/.*/ (&)/'; }
if [ -n "${SSH_CONNECTION-}" ]; then
  __host='\[\e[1;95m\]\u@\h\[\e[0m\]'
else
  __host='\[\e[2m\]\u@\h\[\e[0m\]'
fi
PS1='\n\[\e[1;34m\]\w\[\e[0;33m\]$(__git_branch)\[\e[0m\]  '"$__host"'\n\$ '
unset __host
