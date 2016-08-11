SESSION_NAME=default

tmux has-session -t $SESSION_NAME 2> /dev/null
if [ $? -eq 0 ]
then
  tmux attach -t $SESSION_NAME
  exit
fi

tmux new-session -s $SESSION_NAME -d

# window: monorail
tmux rename-window monorail
tmux send-keys -t $SESSION_NAME 'cd ~/repos/airbnb' C-m

# window
tmux new-window
tmux send-keys -t $SESSION_NAME 'cd ~/repos/airbnb' C-m

# window: rookery
tmux new-window -n rookery
tmux send-keys -t $SESSION_NAME 'cd ~/repos/rookery' C-m

# window
tmux new-window
tmux send-keys -t $SESSION_NAME 'cd ~/repos/rookery' C-m

# window: data
tmux new-window -n data
tmux send-keys -t $SESSION_NAME 'cd ~/repos/data' C-m

# window
tmux new-window
tmux send-keys -t $SESSION_NAME 'cd ~/repos/data' C-m

### Select 1st window
tmux next-window -t $SESSION_NAME

tmux attach -t $SESSION_NAME
