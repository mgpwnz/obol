#!/bin/bash

while true
do


# Menu

PS3='Select an action: '
options=("Install Node" "Create the artifacts" "Run docker" "Check log" "Exit")
select opt in "${options[@]}"
               do
                   case $opt in                           

"Install Node")
echo "============================================================"
echo "Install start"
echo "============================================================"

# set vars
sudo apt-get update && sudo apt-get upgrade -y

sudo apt install make clang pkg-config libssl-dev libclang-dev build-essential git curl ntp jq llvm tmux htop screen unzip -y
apt install docker-compose
install() {
	cd
	if ! docker --version; then
		echo -e "${C_LGn}Docker installation...${RES}"
		sudo apt update && sudo apt upgrade -y
		sudo apt install curl apt-transport-https ca-certificates gnupg lsb-release -y
		. /etc/*-release
		wget -qO- "https://download.docker.com/linux/${DISTRIB_ID,,}/gpg" | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
		echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		sudo apt update
		sudo apt install docker-ce docker-ce-cli containerd.io -y
		docker_version=`apt-cache madison docker-ce | grep -oPm1 "(?<=docker-ce \| )([^_]+)(?= \| https)"`
		sudo apt install docker-ce="$docker_version" docker-ce-cli="$docker_version" containerd.io -y
	fi
	if ! docker-compose --version; then
		echo -e "${C_LGn}Docker Сompose installation...${RES}"
		sudo apt update && sudo apt upgrade -y
		sudo apt install wget jq -y
		local docker_compose_version=`wget -qO- https://api.github.com/repos/docker/compose/releases/latest | jq -r ".tag_name"`
		sudo wget -O /usr/bin/docker-compose "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-`uname -s`-`uname -m`"
		sudo chmod +x /usr/bin/docker-compose
		. $HOME/.bash_profile
	fi
}
uninstall() {
	echo -e "${C_LGn}Docker uninstalling...${RES}"
	sudo systemctl stop docker.service docker.socket
	sudo systemctl disable docker.service docker.socket
	sudo rm -rf `systemctl cat docker.service | grep -oPm1 "(?<=^#)([^%]+)"` `systemctl cat docker.socket | grep -oPm1 "(?<=^#)([^%]+)"` /usr/bin/docker-compose
	sudo apt purge docker-engine docker docker.io docker-ce docker-ce-cli -y
	sudo apt autoremove --purge docker-engine docker docker.io docker-ce -y
	sudo apt autoclean
	sudo rm -rf /var/lib/docker /etc/appasudo rmor.d/docker
	sudo groupdel docker
	sudo rm -rf /etc/docker /usr/bin/docker /usr/libexec/docker /usr/libexec/docker/cli-plugins/docker-buildx /usr/libexec/docker/cli-plugins/docker-scan /usr/libexec/docker/cli-plugins/docker-app /usr/share/keyrings/docker-archive-keyring.gpg
}

# Actions
$function
echo -e "${C_LGn}Done!${RES}"

# Clone repository
git clone https://github.com/ObolNetwork/charon-distributed-validator-cluster.git

# Change directory
cd charon-distributed-validator-cluster/

# Copy the sample environment variables
cp .env.sample .env
sudo chmod -R 666 .charon
break
;;


"Create the artifacts")     
echo "============================================================"
echo "Enter your wallet address"
echo "============================================================"
read ADDRESS
echo export ADDRESS=${ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1
cd $HOME/charon-distributed-validator-cluster/ && \
docker run --rm -v "$(pwd):/opt/charon" obolnetwork/charon:v0.13.0 create cluster --withdrawal-address=${ADDRESS} --nodes 6 --threshold 5

break
;;   

"Run docker")

cd $HOME/charon-distributed-validator-cluster/ && \
docker-compose up --build

sleep 2

echo -e 'To check logs: \e[1m\e[32mcd $HOME/bundlr/validator-rust && \
docker-compose logs -f --tail 100'
echo -e 'Close logs Control+C and continiue install'

break
;;
"Check log")

cd $HOME/charon-distributed-validator-cluster/ && \
docker-compose logs -f --tail 100
;;
"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
