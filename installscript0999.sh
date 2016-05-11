#!/bin/bash
#SET VARIABLES
export MYSQL_ROOT_PASSWORD="TiMi2016"
export APACHE_PORT=80
export DATABASE_HOST="localhost"
export DATABASE_NAME="timi5"
export DATABASE_USER="timi5"
export DATABASE_PASSWORD="timiSQL5"
export SERVER_ADMIN_MAIL="admin@test5.com"
export DOMAIN_NAME="timi5.com"
#----------------------------------------------------
#INSTALLING THE NECESSARY PACKAGES
apt-get update
apt-get install apache2
apt-get install mysql-server
apt-get install mysql-client
apt-get install php5
apt-get install libapache2-mod-php5
apt-get install php5-mcrypt
apt-get install php5-mysql
apt-get install php5-cli
apt-get install php5-gd
apt-get install php5-curl
apt-get install libssh2-php
apt-get install unzip
apt-get install drush
#----------------------------------------------------
#DATABASE OPERATIONS
mysql -uroot -h$DATABASE_HOST -p$MYSQL_ROOT_PASSWORD -e "DROP DATABASE IF EXISTS $DATABASE_NAME;"
mysql -uroot -h$DATABASE_HOST -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE $DATABASE_NAME;"
mysql -uroot -h$DATABASE_HOST -p$MYSQL_ROOT_PASSWORD -e "DROP USER $DATABASE_USER@$DATABASE_HOST;"
mysql -uroot -h$DATABASE_HOST -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
mysql -uroot -h$DATABASE_HOST -p$MYSQL_ROOT_PASSWORD -e "CREATE USER $DATABASE_USER@$DATABASE_HOST IDENTIFIED BY '$DATABASE_PASSWORD';"
mysql -uroot -h$DATABASE_HOST -p$MYSQL_ROOT_PASSWORD -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,INDEX,ALTER,CREATE TEMPORARY TABLES,LOCK TABLES ON $DATABASE_NAME.* TO $DATABASE_USER@$DATABASE_HOST;"
mysql -uroot -h$DATABASE_HOST -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
#----------------------------------------------------
#UPDATE PHP.INI
#sed -i '/expose_php/c\expose_php = Off' /etc/php5/apache2/php.ini
#sed -i '/allow_url_fopen/c\allow_url_fopen = Off' /etc/php5/apache2/php.ini
sed -i '/max_execution_time/c\max_execution_time = 300' /etc/php5/apache2/php.ini
sed -i '/memory_limit/c\memory_limit = 256M' /etc/php5/apache2/php.ini
#sed -i '/display_errors/c\display_errors = Off' /etc/php5/apache2/php.ini
#sed -i '/session.cache_limiter/c\session.cache_limiter = nocache' /etc/php5/apache2/php.ini
#sed -i '/session.auto_start/c\session.auto_start = 0' /etc/php5/apache2/php.ini
#echo 'magic_quotes_gpc = off' >> /etc/php5/apache2/php.ini
#echo 'register_globals = off' >> /etc/php5/apache2/php.ini
#----------------------------------------------------
#Apache Rewrite Enable
a2enmod rewrite
#----------------------------------------------------
#Create the Directory Structure
mkdir -p /var/www/timi/public_html
chown -R $USER:$USER /var/www/timi/public_html
chmod -R 755 /var/www/timi
#----------------------------------------------------
#Create and Enable Virtual Host
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/timi.conf
echo "<VirtualHost *:$APACHE_PORT>
    ServerAdmin $SERVER_ADMIN_MAIL
    ServerName  $DOMAIN_NAME
    ServerAlias www.$DOMAIN_NAME
    DocumentRoot /var/www/timi/public_html
    <Directory "/var/www/timi/public_html">
        AllowOverride All
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/$DOMAIN_NAME.error.log
    CustomLog ${APACHE_LOG_DIR}/$DOMAIN_NAME.access.log combined
</VirtualHost>">/etc/apache2/sites-available/timi.conf
a2ensite timi.conf
#----------------------------------------------------
#Apache Server Restarting
service apache2 restart
#---------------------------------------------------
#Git clone the application source files
mkdir /var/www/timi/github
cd /var/www/timi/github
wget https://github.com/holding-it/timi/archive/master.zip
cd /var/www/timi
drush dl drupal-7 --drupal-project-rename=drupal
cp -avr /var/www/timi/drupal/* /var/www/timi/public_html
cd /var/www/timi/public_html
drush site-install standard --db-url='mysql://'$DATABASE_USER':'$DATABASE_PASSWORD'@'$DATABASE_HOST'/'$DATABASE_NAME'' --site-name=$DOMAIN_NAME
if [ -d /var/www/timi/public_html/sites/default/files ]; then
    rm -rf /var/www/timi/public_html/sites/default/files
fi
if [ -d /var/www/timi/public_html/sites/all ]; then
    rm -rf /var/www/timi/public_html/sites/all
fi
drush sql-drop --database=default --yes
cd /var/www/timi/github
unzip /var/www/timi/github/master.zip
mysql -uroot  -h$DATABASE_HOST -p$MYSQL_ROOT_PASSWORD $DATABASE_NAME < /var/www/timi/github/timi-master/db/timi.sql
cp -avr /var/www/timi/github/timi-master/all /var/www/timi/public_html/sites
unzip /var/www/timi/public_html/sites/all/libraries.zip -d /var/www/timi/public_html/sites/all
rm /var/www/timi/public_html/sites/all/libraries.zip
unzip /var/www/timi/public_html/sites/all/modules.zip -d /var/www/timi/public_html/sites/all
rm /var/www/timi/public_html/sites/all/modules.zip
unzip /var/www/timi/public_html/sites/all/themes.zip -d /var/www/timi/public_html/sites/all
rm /var/www/timi/public_html/sites/all/themes.zip
cp -avr /var/www/timi/github/timi-master/files /var/www/timi/public_html/sites/default
unzip /var/www/timi/public_html/sites/default/files/files.zip  -d /var/www/timi/public_html/sites/default
rm /var/www/timi/public_html/sites/default/files/files.zip
cp -avr /var/www/timi/github/timi-master/mob /var/www/timi/public_html
rm -rf /var/www/timi/github
rm -rf /var/www/timi/drupal
chmod 644 /var/www/timi/public_html/sites/default/settings.php
chown -R :www-data /var/www/timi/public_html/sites/default/files
chmod -R 775 /var/www/timi/public_html/sites/default/files
#---------------------------------------------------
cd /var/www/timi/public_html
drush updb
drush cc all