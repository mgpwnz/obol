#!/bin/bash

while true
do


# Menu

PS3='Select an action: '
options=("Install Pre-requisites" "Download the components" "backup keys" "Run docker" "Check log" "Exit")
select opt in "${options[@]}"
               do
                   case $opt in                           

"Install Pre-requisites")
echo "============================================================"
echo "Install start"
echo "============================================================"

# set vars
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install curl wget git screen jq libpq-dev libssl-dev \
build-essential pkg-config openssl ocl-icd-opencl-dev \
libopencl-clang-dev libgomp1 -y
#docker
# Default variables
dive="false"
function="install"

# Options
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/colors.sh) --
option_value(){ echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
		echo
		echo -e "${C_LGn}Functionality${RES}: the script installs or uninstalls Docker"
		echo
		echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES}"
		echo
		echo -e "${C_LGn}Options${RES}:"
		echo -e "  -h,  --help       show the help page"
		echo -e "  -d,  --dive       install Dive (images analyser)"
		echo -e "  -un, --uninstall  uninstall Docker (${C_R}completely delete all images and containers${RES})"
		echo
		echo -e "${C_LGn}Useful URLs${RES}:"
		echo -e "https://github.com/SecorD0/utils/blob/main/installers/docker.sh - script URL"
		echo -e "https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository — Docker installation"
		echo -e "https://docs.docker.com/compose/install/#install-compose — Docker Compose installation"
		echo -e "https://github.com/wagoodman/dive#installation — Dive installation"
		echo -e "https://t.me/OnePackage — noderun and tech community"
		echo -e "https://learning.1package.io — guides and articles"
		echo -e "https://teletype.in/@letskynode — guides and articles"
		echo
		return 0 2>/dev/null; exit 0
		;;
	-d|--dive)
		dive="true"
		shift
		;;
	-u|-un|--uninstall)
		function="uninstall"
		shift
		;;
	*|--)
		break
		;;
	esac
done

# Functions
install() {
	touch $HOME/.bash_profile
	cd
	if ! docker --version; then
		echo -e "${C_LGn}Docker installation...${RES}"
		sudo apt update
		sudo apt upgrade -y
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
		sudo apt update
		sudo apt upgrade -y
		sudo apt install wget jq -y
		local docker_compose_version=`wget -qO- https://api.github.com/repos/docker/compose/releases/latest | jq -r ".tag_name"`
		sudo wget -O /usr/bin/docker-compose "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-`uname -s`-`uname -m`"
		sudo chmod +x /usr/bin/docker-compose
		. $HOME/.bash_profile
	fi
	if [ "$dive" = "true" ] && ! dpkg -s dive | grep -q "ok installed"; then
		echo -e "${C_LGn}Dive installation...${RES}"
		wget https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb
		sudo apt install ./dive_0.9.2_linux_amd64.deb
		rm -rf dive_0.9.2_linux_amd64.deb
	fi
}
uninstall() {
	echo -e "${C_LGn}Docker uninstalling...${RES}"
	sudo dpkg -r dive
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

break
;;

"Download the components")
# Clone repository
git clone https://github.com/ObolNetwork/charon-distributed-validator-node.git
sleep 5
cd charon-distributed-validator-node
mkdir .charon
chmod o+w .charon
# Change ports
cp .env.sample .env
sed -i -e "s%#MONITORING_PORT_GRAFANA=%MONITORING_PORT_GRAFANA=3008%g" $HOME/charon-distributed-validator-node/.env
sed -i -e "s%#LIGHTHOUSE_PORT_P2P=%LIGHTHOUSE_PORT_P2P=9100%g" $HOME/charon-distributed-validator-node/.env
sed -i -e "s%#GETH_PORT_P2P=%GETH_PORT_P2P=32303%g" $HOME/charon-distributed-validator-node/.env
# Change directory 
sleep 2
docker run --rm -v "$(pwd):/opt/charon" obolnetwork/charon:v0.13.0 create enr
sleep 2
#backup
mkdir $HOME/backup_Obol/
cp $HOME/charon-distributed-validator-node/.charon/charon-enr-private-key $HOME/backup_Obol/
break
exit
;;
"backup keys")
# Change directory
cp -r $HOME/charon-distributed-validator-node/.charon/ $HOME/backup_Obol/
;;
"Run docker")
rm -r ./data/lighthouse
cd $HOME/charon-distributed-validator-node && docker-compose up -d

break
;;
"Check log")
cd $HOME/charon-distributed-validator-node && docker-compose logs -f --tail 100
exit
;;
"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
