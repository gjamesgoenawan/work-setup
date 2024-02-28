#!/bin/bash

parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

DIR="$( cd "$( dirname "$0" )" && pwd )"
rm config/workspace.yml
echo "Please enter your password: "
stty -echo
read login
stty echo

eval $(parse_yaml config/config.yml "CONF_")
echo """session_name: workspace
windows:
- window_name: statistics
  layout: tiled
  panes: 
    - htop
    - nvtop

- window_name: servers
  layout: tiled
  shell_command_before:
      - source ~/.bashrc
      - clear
  panes:
    - shell_command:
      - cd $CONF_notebook_dir_posix
      - conda activate $CONF_notebook_env
      - jupyter notebook --config $DIR/config/jupyter_server_config.py --no-browser --port $CONF_notebook_port
    - shell_command:
      - cd $CONF_tensorboard_dir_posix
      - conda activate $CONF_tensorboard_env
      - tensorboard --logdir=$CONF_tensorboard_logdir --host 0.0.0.0 --port $CONF_tensorboard_port
    - shell_command:
      - conda activate $CONF_landing_env
      - sudo env PATH="$"PATH python landing.py
    - shell_command:
      - cd ../lean-conky-config
      - conda activate ps
      - ./start-lcc.sh
      - conda deactivate
      - code-server
    """ >> config/workspace.yml

tmux kill-session -t workspace
tmuxp load -d config/workspace.yml
tmux send-keys -t workspace:servers.2 $login Enter
tmux attach -t workspace
