# obol solo cluster
wget -q -O obol_leader.sh https://raw.githubusercontent.com/mgpwnz/obol/main/obol_leader.sh && chmod +x obol_leader.sh && ./obol_leader.sh

#1 пункт оновлення пакетів та системи + встановлення докер
#2 клонування репозиторію, зміна стандартних портів, створення ENR, бекап приватного ключа charon в директорію $HOME/backup_Obol/
# На цьому кроці нам потрібно, пройти реєстрацію, отримати конфіг та запустити DKG 
#3 бекап .charon/
#4 запуск ноди
#5 перевірка логів
#6 вихід

Відновлення з копії або перенос на інший сервер!
Для початку завантажити backup_obol
wget -q -O obol_restore.sh https://raw.githubusercontent.com/mgpwnz/obol/main/obol_restore.sh && chmod +x obol_restore.sh && ./obol_restore.sh








У кого не стартует в обол после запуска или переезда синхронизация - выполняем команду:

docker-compose -f $HOME/charon-distributed-validator-node/docker-compose.yml down

sed -i -e 's%--checkpoint-sync-url=.*%--checkpoint-sync-url=https://goerli.beaconstate.info%g' "$HOME/charon-distributed-validator-node/docker-compose.yml"

docker-compose -f $HOME/charon-distributed-validator-node/docker-compose.yml up -d



wget -q -O obol_ports.sh https://raw.githubusercontent.com/mgpwnz/obol/main/obol_ports.sh && chmod +x obol_ports.sh && ./obol_ports.sh


sed -i -e 's%--checkpoint-sync-url=https://goerli.beaconstate.info%--checkpoint-sync-url=https://goerli.checkpoint-sync.ethdevops.io%g' "$HOME/charon-distributed-validator-node/docker-compose.yml"


