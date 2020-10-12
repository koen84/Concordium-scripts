#!/bin/bash

echo "Installing concordium the docker way, and all its dependencies."
echo "Tested on Ubuntu 18.04 LTS."

## variables
useraccount="concordium"
tmux_session="concordium"

linuxfile="concordium-software-linux-0.3.2.tar.gz"
linuxdl="https://client-distribution-testnet.concordium.com/$linuxfile"

## detects IP address of adapter over which you connect to internet
middleware_address="$(ip route get 1 | head -1 | awk '{print $7}')"

## logic
script="$(pwd)/${BASH_SOURCE[0]}"

if [ $USER != "$useraccount" ]; then
	## CHECK root
	if ! [ $(id -u) = 0 ]; then
	   echo "Script must be run as root / sudo."
	   exit 1
	fi

	## System update
	echo -e "\n$(tput setaf 3)## updating system$(tput sgr0)"
	apt-get update
	apt-get upgrade -y

	echo -e "\n## installing packages"
	apt-get install curl tmux

	## Install docker
	echo -e "\n$(tput setaf 3)## installing docker$(tput sgr0)"
	apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	apt-get update
	apt-get install docker-ce docker-ce-cli containerd.io

	## Docker test
	# docker run hello-world

	## Switch user
	echo -e "\n$(tput setaf 3)## switching user$(tput sgr0)"
	echo "run 'bash $script' again"
	su $useraccount
	exit 0

else 

	## Download concordium
	echo -e "\n$(tput setaf 3)## downloading concordium$(tput sgr0)"
	mkdir $HOME/Documents
	cd $HOME/Documents
	curl $linuxdl -LO
	tar -xzf $linuxfile
	
	## Start concordium-node
	cat <<EOD > "$HOME/Documents/concordium-software/run_concordium_tmux.sh"
	# variables
	tmux_session=$tmux_session
	middleware_address=$middleware_address
	# logic
	echo -e "\n$(tput setaf 3)## stop node if running$(tput sgr0) (to avoid conflicts)"
	echo -e "\n" | $HOME/Documents/concordium-software/concordium-node-stop
	echo -e "\n$(tput setaf 3)## starting concordium-node$(tput sgr0)"
	tmux new -d -s \$tmux_session
	tmux send -t \$tmux_session C-C
	tmux send -t \$tmux_session "\$HOME/Documents/concordium-software/concordium-node --listen-middleware-address \$middleware_address" ENTER
EOD
	chmod +x $HOME/Documents/concordium-software/run_concordium_tmux.sh
	$HOME/Documents/concordium-software/run_concordium_tmux.sh
	
	## Finish
	echo -e "\n$(tput setaf 3)## installation finished & node start initialised$(tput sgr0)"
	echo "Your node runs within tmux, so you can safely logout from server."
	echo "Check your node status by running 'tmux a -t $tmux_session'"
	echo "Disconnect from tmux without stopping your node, press 'CTRL+b' and then 'd'"
	
	echo -e "\n$(tput setaf 3)## Complete node start by filling required info on next screen.$(tput sgr0)"
	read -p "Press any key to continue or 'CTRL+C' to abort (remember to fill it asap)."
	tmux a -t $tmux_session
	
	exit 0
fi
