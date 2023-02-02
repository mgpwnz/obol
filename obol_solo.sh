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
#Install docker compose
curl -s https://raw.githubusercontent.com/SecorD0/utils/main/installers/docker.sh | bash &>/dev/null
# Actions
$function
echo -e "${C_LGn}Done!${RES}"

# Clone repository
git clone https://github.com/ObolNetwork/charon-distributed-validator-cluster.git

# Change directory
cd charon-distributed-validator-cluster/

# Copy the sample environment variables
cp .env.sample .env

break
;;


"Create the artifacts")     
sudo chmod 777 -R /root/charon-distributed-validator-cluster/ 
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
sudo docker run --rm -v "$(pwd):/opt/charon" obolnetwork/charon:v0.13.0 create cluster --withdrawal-address=${ADDRESS} --nodes 6 --threshold 5 --name=${NAME}

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
