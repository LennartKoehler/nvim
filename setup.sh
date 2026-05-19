#!/bin/bash

#test
ln -sf ~/.config/nvim/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/.config/nvim/kitty.conf ~/.config/kitty/kitty.conf

chmod +x ~/.config/nvim/tmux/tmux_agent
chmod +x ~/.config/nvim/tmux/tmux_dev


PATH_ENTRY='$HOME/.config/nvim/tmux'
LINE='export PATH="$PATH:$HOME/.config/nvim/tmux"'
BASHRC="$HOME/.bashrc"

# Only add if not already present
if ! grep -Fxq "$LINE" "$BASHRC"; then
    echo "$LINE" >> "$BASHRC"
    echo "Added $PATH_ENTRY to PATH in $BASHRC"
else
    echo "$PATH_ENTRY already exists in PATH"
fi

# Reload bashrc for current shell if sourced
source "$BASHRC"
