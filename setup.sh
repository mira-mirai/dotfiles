#!/bin/bash

# setup script for new computers/accounts

# get dir for dotfiles repo
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# symlink each dotfile into ~, backing up any real file already there
for f in .bashrc .bash_profile .aliases .path .vimrc .gitignore_global .gitconfig .inputrc; do
  target="$HOME/$f"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$SCRIPT_DIR/$f" ]; then
    echo "ok: $target already linked"
    continue
  fi
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "backing up existing $target to $target.bak"
    mv "$target" "$target.bak"
  fi
  ln -s "$SCRIPT_DIR/$f" "$target"
  echo "linked: $target -> $SCRIPT_DIR/$f"
done

# macOS: turn off Terminal.app's separate per-tab histories so every tab shares ~/.bash_history
if [[ $OSTYPE == darwin* ]] && [ ! -e "$HOME/.bash_sessions_disable" ]; then
  touch "$HOME/.bash_sessions_disable"
  echo "created ~/.bash_sessions_disable (one shared history for all Terminal tabs)"
fi

# macOS: install the Gruvbox Dark Terminal.app profile and make it the default for new windows.
# (rebuild the profile after editing colors: osascript -l JavaScript terminal/make-gruvbox-dark.js "terminal/Gruvbox Dark.terminal")
if [[ $OSTYPE == darwin* ]]; then
  if ! defaults read com.apple.Terminal "Window Settings" 2>/dev/null | grep -q '"Gruvbox Dark"'; then
    open "$SCRIPT_DIR/terminal/Gruvbox Dark.terminal"   # importing it also opens one window
    sleep 2
    echo "imported the Gruvbox Dark Terminal profile"
  fi
  osascript -e 'tell application "Terminal"
    set default settings to settings set "Gruvbox Dark"
    set startup settings to settings set "Gruvbox Dark"
  end tell' && echo "ok: Gruvbox Dark is the default Terminal profile"
fi

# ~/.path.local is for PATH entries specific to this machine and is not part of the repo
[ -f "$HOME/.path.local" ] || echo "note: create ~/.path.local if this machine needs extra PATH entries"
