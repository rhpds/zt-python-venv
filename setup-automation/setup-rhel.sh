#!/bin/bash

# WHarris workaround for EPEL 10 being added to RHEL 9 machines from Satellite issue
subscription-manager repos --disable=Red_Hat_RHDP_Labs_Extra_Packages_for_Enterprise_Linux_EPEL_10

#step 1: make a script
tee ~/startup-tmux.sh << EOF
TMUX='' tmux new-session -d -s 'rhel-session' > /dev/null 2>&1
tmux set -g pane-border-status top
tmux setw -g pane-border-format ' #{pane_index} #{pane_current_command}'
tmux set -g mouse on
tmux set mouse on
tmux unbind -n MouseDown3Pane
EOF

#step 2: make it executable
chmod +x ~/startup-tmux.sh
#step 3: use cron to execute 
echo "@reboot ~/startup-tmux.sh" | crontab -

#step 4: start tmux for the lab
~/startup-tmux.sh

#create a nice little test program for our venv
tee /home/api.py << EOF
import requests
import json
import pandas
from tabulate import tabulate

response = requests.get("https://catfact.ninja/fact?max_length=100").json()
frame = pandas.json_normalize(response)
print(tabulate(frame,headers="keys",tablefmt="rounded_grid"))
EOF

echo "DONE" >> /root/post-run.log
