#!/bin/bash

while true
do


# Menu

PS3='Select an action: '
options=("Install Pre-requisites" "Download the components" "Create the artifacts" "Run docker" "Check log" "Exit")
select opt in "${options[@]}"
               do
                   case $opt in                           

"Install Pre-requisites")
echo "============================================================"
echo "Install start"
echo "============================================================"

# set vars
sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install curl wget jq libpq-dev libssl-dev \
build-essential pkg-config openssl ocl-icd-opencl-dev \
libopencl-clang-dev libgomp1 -y
echo "Starting docker community edition install..."
echo "Removing any old instances of docker and installing dependencies"
apt remove -y docker docker-engine docker.io containerd runc
apt update
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

echo "Dowloading latest docker and adding official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

echo "Pulling the latest repository"
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt update

echo "Installing docker community edition"
apt install -y docker-ce docker-ce-cli containerd.io

echo "Docker install completed, installing docker-compose"

echo "Dowloading docker-compose v2.5.0 - be sure to update to the latest stable"
curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

echo "Setting binary permissions"
chmod +x /usr/local/bin/docker-compose

echo “Docker and docker-compose install complete”

# Run docker as non-root user on Ubuntu
sudo usermod -aG docker $USER

# Actions
$function
echo -e "${C_LGn}Done!${RES}"
break
;;

"Download the components")
# Clone repository
git clone https://github.com/ObolNetwork/charon-distributed-validator-cluster.git

# Change directory
cd charon-distributed-validator-cluster/

# Copy the sample environment variables
cp .env.sample .env
# priv
sudo chmod 777 -R /root/charon-distributed-validator-cluster/ 
break
;;


"Create the artifacts")     

echo "============================================================"
echo "Enter your wallet address 0x000000000000000000000000000000000000 "
echo "============================================================"
read ADDRESS
echo export ADDRESS=${ADDRESS} >> $HOME/.bash_profile

echo "============================================================"
echo "Enter your cluster name"
echo "============================================================"
read NAME
echo export NAME=${NAME} >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 1
cd $HOME/charon-distributed-validator-cluster/ && \
sudo docker run --rm -v "$(pwd):/opt/charon" obolnetwork/charon:v0.13.0 create cluster --withdrawal-address=${ADDRESS} --nodes 6 --threshold 5 --name=${NAME} --split-existing-keys=true

break
;;   

"Run docker")

cd $HOME/charon-distributed-validator-cluster/ && \
docker-compose up -d

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
