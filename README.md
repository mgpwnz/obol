obol solo cluster
wget -q -O obol_leader.sh https://raw.githubusercontent.com/mgpwnz/obol/main/obol_leader.sh && chmod +x obol_leader.sh && ./obol_leader.sh

#1 пункт оновлення пакетів та системи + встановлення докер
#2 клонування репозиторію, зміна стандартних портів, створення ENR, бекап приватного ключа charon в директорію $HOME/backup_Obol/
На цьому кроці нам потрібно, пройти реєстрацію, отримати конфіг та запустити DKG 
#3 бекап .charon/
#4 запуск ноди
#5 перевірка логів
#6 вихід

# Відновлення з копії або перенос на інший сервер!
Для початку завантажити backup_obol
wget -q -O obol_restore.sh https://raw.githubusercontent.com/mgpwnz/obol/main/obol_restore.sh && chmod +x obol_restore.sh && ./obol_restore.sh













