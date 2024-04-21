#!/bin/sh
tmux send-keys "nvim" Enter
tmux new-window -n process "devenv up"
