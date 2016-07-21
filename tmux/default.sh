tmux new-session -s default -d

# window: monorail
tmux rename-window monorail
tmux send-keys -t default 'cd ~/repos/airbnb' C-m

# window
tmux new-window
tmux send-keys -t default 'cd ~/repos/airbnb' C-m

# window: rookery
tmux new-window -n rookery
tmux send-keys -t default 'cd ~/repos/rookery' C-m

# window
tmux new-window
tmux send-keys -t default 'cd ~/repos/rookery' C-m

# window: data
tmux new-window -n data
tmux send-keys -t default 'cd ~/repos/data' C-m

# window
tmux new-window
tmux send-keys -t default 'cd ~/repos/data' C-m

### Select 1st window
tmux next-window -t default

tmux attach -t default
