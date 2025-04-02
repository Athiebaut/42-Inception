#!/bin/sh

if [ ! -d /var/lib/mysql/$DB_NAME ]
then

rc-service mariadb setup
rc-service mariadb start

mariadb -e "DROP DATABASE IF EXISTS test"

mariadb -e "CREATE DATABASE IF NOT EXISTS $DB_NAME"

mariadb -e "CREATE USER IF NOT EXISTS $DB_ROOT_USER@localhost IDENTIFIED BY '$DB_ROOT_PASSWD'"
mariadb -e "CREATE USER IF NOT EXISTS $DB_USER@'%' IDENTIFIED BY '$DB_PASSWD'"

mariadb -e "GRANT ALL PRIVILEGES on *.* TO $DB_ROOT_USER@localhost WITH GRANT OPTION"
mariadb -e "GRANT ALL PRIVILEGES on $DB_NAME.* TO $DB_USER@'%' IDENTIFIED BY '$DB_PASSWD'"

mariadb-admin reload

mariadb -u$DB_ROOT_USER -p$DB_ROOT_PASSWD -e "DROP USER mysql@localhost"
mariadb -u$DB_ROOT_USER -p$DB_ROOT_PASSWD -e "DROP USER root@localhost"
mariadb -u$DB_ROOT_USER -p$DB_ROOT_PASSWD -e "DROP USER ''@localhost"
mariadb -u$DB_ROOT_USER -p$DB_ROOT_PASSWD -e "DROP USER ''@$HOSTNAME"

#   Need to stop current instance of server or mariadbd-safe will stop itself if it is a second instance...
mariadb-admin -u$DB_ROOT_USER -p$DB_ROOT_PASSWD shutdown
fi

sed -i -E "s/#bind-address/bind-address/" /etc/my.cnf.d/mariadb-server.cnf
sed -i -E "s/skip-networking/#skip-networking/" /etc/my.cnf.d/mariadb-server.cnf

exec "$@"
