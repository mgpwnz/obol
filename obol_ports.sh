#!/bin/bash

while true
do


# Menu

PS3='Select an action: '
options=("change only 3000" "standart ports" "change 3 ports" "Run docker" "Check log" "Exit")
select opt in "${options[@]}"
               do
                   case $opt in                           

"change only 3000")
# Change ports
cd $HOME/charon-distributed-validator-node/ && docker compose down
sleep 20
rm .env
cp .env.sample .env
sed -i -e "s%#MONITORING_PORT_GRAFANA=%MONITORING_PORT_GRAFANA=3008%g" $HOME/charon-distributed-validator-node/.env
break
;;
"standart ports")
# Change standart
cd $HOME/charon-distributed-validator-node/ && docker compose down
sleep 20
rm .env
;;
"change 3 ports")
# Change ports
cd $HOME/charon-distributed-validator-node/ && docker compose down
sleep 20
rm .env
cp .env.sample .env
sed -i -e "s%#MONITORING_PORT_GRAFANA=%MONITORING_PORT_GRAFANA=3008%g" $HOME/charon-distributed-validator-node/.env
sed -i -e "s%#LIGHTHOUSE_PORT_P2P=%LIGHTHOUSE_PORT_P2P=9100%g" $HOME/charon-distributed-validator-node/.env
sed -i -e "s%#GETH_PORT_P2P=%GETH_PORT_P2P=32303%g" $HOME/charon-distributed-validator-node/.env
break
;;

"Run docker")
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
