#!/bin/sh

cd /srv/www/wordpress

if [ ! -f wp-cli.phar ];
then
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
fi

if [ ! -f /srv/www/wordpress/wp-config.php ];
then
    php83 wp-cli.phar core download --version=6.5.5
    php83 wp-cli.phar config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWD --dbhost=mariadb:3306
    php83 wp-cli.phar core install --url=$URL --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWD --admin_email=$WP_ADMIN_EMAIL;

    php83 wp-cli.phar user create --role=author $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWD
    chown -R nobody:nobody /srv/www/wordpress
fi

sed -i -E "s/^listen = 127.0.0.1/listen = 0.0.0.0/" /etc/php83/php-fpm.d/www.conf
sed -i -E "s/;ping.path/ping.path/" /etc/php83/php-fpm.d/www.conf
sed -i -E "s/;ping.response/ping.response/" /etc/php83/php-fpm.d/www.conf

exec "$@"
