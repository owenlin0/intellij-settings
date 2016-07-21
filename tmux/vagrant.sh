tmux new-session -s vagrant -d

### Monorail
# first pane
tmux rename-window monorail
tmux send-keys -t vagrant 'cd ~/repos/airbnb && vagrant ssh' C-m
tmux send-keys -t vagrant 'cd repos/airbnb && bundle install && zeus start' C-m

# second pane
tmux split-window -h -t vagrant
tmux send-keys -t vagrant 'sleep $[ ( $RANDOM % 5 ) + 1 ]s; cd ~/repos/airbnb && vagrant ssh' C-m
tmux send-keys -t vagrant 'cd repos/airbnb' C-m

# third pane
tmux select-pane -L
tmux split-window -v -t vagrant
tmux send-keys -t vagrant 'sleep $[ ( $RANDOM % 5 ) + 1 ]s; cd ~/repos/airbnb && vagrant ssh' C-m
tmux send-keys -t vagrant 'cd repos/airbnb' C-m

### Rookery
tmux new-window -n rookery
# first pane
tmux send-keys -t vagrant 'sleep $[ ( $RANDOM % 5 ) + 1 ]s; cd ~/repos/airbnb && vagrant ssh' C-m
tmux send-keys -t vagrant 'cd repos/rookery' C-m
# second pane
tmux split-window -h -t vagrant
tmux send-keys -t vagrant 'sleep $[ ( $RANDOM % 5 ) + 1 ]s; cd ~/repos/airbnb && vagrant ssh' C-m
tmux send-keys -t vagrant 'cd repos/rookery' C-m

### Open window
tmux new-window

### Select 1st window
tmux next-window -t vagrant

tmux attach -t vagrant
