#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ./config.sh
. ./colors.sh
. ./environment.sh

#send a message
verbose "Configuring PHP"

php_version=8.2

apt-get update -y

#install dependencies
apt-get install -y nginx

if [ ."$php_version" = ."8.2" ]; then
	apt-get install -y --no-install-recommends php8.2 php8.2-common php8.2-cli php8.2-dev php8.2-fpm php8.2-pgsql php8.2-sqlite3 php8.2-odbc php8.2-curl php8.2-imap php8.2-xml php8.2-gd php8.2-mbstring php8.2-ldap
fi

if [ ."$php_version" = ."8.2" ]; then
        verbose "version 8.2"
        php_ini_file='/etc/php/8.2/fpm/php.ini'
fi
sed 's#post_max_size = .*#post_max_size = 80M#g' -i $php_ini_file
sed 's#upload_max_filesize = .*#upload_max_filesize = 80M#g' -i $php_ini_file
sed 's#;max_input_vars = .*#max_input_vars = 8000#g' -i $php_ini_file
sed 's#; max_input_vars = .*#max_input_vars = 8000#g' -i $php_ini_file

#install ioncube
# if [ .$cpu_architecture = .'x86' ]; then
# 	. ./ioncube.sh
# fi

#restart php-fpm
systemctl daemon-reload
systemctl restart php8.2-fpm