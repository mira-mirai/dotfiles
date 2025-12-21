echo "loading .bashrc"

# homebrew stuff
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

#lets keep aliases in their own file
source .aliases

#other path updates
source .path
