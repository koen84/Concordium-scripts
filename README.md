# Concordium-scripts
My collection of scripts for concordium on Ubuntu 18.04 LTS. (Might work on other distros using apt packages manager, like Debian.) YMMV - use at your own risk

## install_concordium_dockerised.sh
_Install your concordium node, from start to finsih, in 3 simple steps.  Takes care of all dependencies and privileges. By default creates a user "concordium" and a tmux session "concordium" to run your node._
1. Copy / download script to your server.
2. Run the script as root or with sudo.
3. Run the script again as "concordium" user.

This script does **NOT** meddle with your firewall.  It does however automatically prepare your node to be accessed from a different computer.
