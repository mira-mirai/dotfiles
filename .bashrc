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
# on macOS's bash 3.2 only homebrew's older `bash-completion` package works, not `bash-completion@2`
if [ -z "${BASH_COMPLETION_VERSINFO-}" ] && [ -z "${BASH_COMPLETION-}" ]; then
  for f in /usr/share/bash-completion/bash_completion /etc/bash_completion \
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

# linux: let `less` open archives and other non-text files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# lets keep aliases in their own file
echo "loading ~/.aliases"
source ~/.aliases

# prompt: blank line, then full path (blue) + git branch (yellow) + user@host (dim),
# with commands typed on their own line below
__git_branch() { git symbolic-ref --short HEAD 2>/dev/null | sed 's/.*/ (&)/'; }
PS1='\n\[\e[1;34m\]\w\[\e[0;33m\]$(__git_branch)\[\e[0m\]  \[\e[2m\]\u@\h\[\e[0m\]\n\$ '
