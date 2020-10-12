# Concordium-scripts
My collection of scripts for concordium on Ubuntu 18.04 LTS. YMMV - use at your own risk

## install_concordium_dockerised.sh
_Install your concordium node, from start to finsih, in 3 simple steps.  Takes care of all dependencies and access. By default will create a user "concordium" to run the node under. Will run the node in a tmux session "concordium" so you can safely exit from your server and the node will keep running._
1. Copy / download script to your server.
2. Run the script as root or with sudo.
3. Run the script again as "concordium" user.

This script does **NOT** meddle with your firewall.  It does however automatically prepare your node to be accessed from a different computer.
