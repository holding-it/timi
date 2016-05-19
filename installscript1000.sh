#!/bin/bash
#SET VARIABLES
export APACHE_PORT=80
export APACHE_LOGS_DIRECTORY="/var/log/apache2"
export MYSQL_PORT=3306
export DATABASE_HOST="80.247.66.193"
export DATABASE_ADMIN_USER="miskolc"
export DATABASE_ADMIN_PASSWORD="F4UXoIm1yGUHxTIv"
export DATABASE_USER="timi"
export DATABASE_PASSWORD="xxxxxx"
export DATABASE_NAME="timi"
export SERVER_ADMIN_MAIL="admin@test.com"
export DOMAIN_NAME="timi.miskolc.hu"
export APPLICATION_DIRECTORY="/var/www/timi"
#OR /var/www/html/timi
#----------------------------------------------------
#INSTALLING THE NECESSARY PACKAGES
apt-get update
apt-get install apache2 -y
apt-get install php5 -y
apt-get install libapache2-mod-php5 -y
apt-get install php5-mcrypt -y
apt-get install php5-mysql -y
apt-get install php5-cli -y
apt-get install php5-gd -y
apt-get install php5-curl -y
apt-get install libssh2-php -y
apt-get install unzip -y
apt-get install drush -y
#----------------------------------------------------
#DATABASE OPERATIONS
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "DROP DATABASE IF EXISTS $DATABASE_NAME;"
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "CREATE DATABASE $DATABASE_NAME;"
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "DROP USER $DATABASE_USER@$DATABASE_HOST;"
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "FLUSH PRIVILEGES;"
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "CREATE USER $DATABASE_USER@% IDENTIFIED BY '$DATABASE_PASSWORD';"
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,INDEX,ALTER,CREATE TEMPORARY TABLES,LOCK TABLES ON $DATABASE_NAME.* TO $DATABASE_USER@$DATABASE_HOST;"
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "FLUSH PRIVILEGES;"
#----------------------------------------------------
#UPDATE PHP.INI IF NECESSARY
PHP_MEMORY_LIMIT="$(sed -ne '/^memory_limit/s/[^0-9]//gp' /etc/php5/apache2/php.ini)"
PHP_MAX_EXECUTION_TIME="$(sed -ne '/^max_execution_time/s/[^0-9]//gp' /etc/php5/apache2/php.ini)"
if [ "$PHP_MEMORY_LIMIT" -lt 256 ]; then
sed -i '/memory_limit/c\memory_limit = 256M' /etc/php5/apache2/php.ini
fi

if [ "$PHP_MAX_EXECUTION_TIME" -lt 300 ]; then
sed -i '/max_execution_time/c\max_execution_time = 300' /etc/php5/apache2/php.ini 
fi

#----------------------------------------------------
#APACHE REWRITE ENABLE
a2enmod rewrite
#----------------------------------------------------
#CCREATE THE DIRECTORY STRUCTURE
mkdir -p $APPLICATION_DIRECTORY/public_html
chown -R $USER:$USER $APPLICATION_DIRECTORY/public_html
chmod -R 755 $APPLICATION_DIRECTORY
#----------------------------------------------------
#CREATE AND ENABLE VIRTUAL HOST
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/timi.conf
echo "<VirtualHost *:$APACHE_PORT>
    ServerAdmin $SERVER_ADMIN_MAIL
    ServerName  $DOMAIN_NAME
    ServerAlias www.$DOMAIN_NAME
    DocumentRoot $APPLICATION_DIRECTORY/public_html
    <Directory "$APPLICATION_DIRECTORY/public_html">
        AllowOverride All
    </Directory>
    ErrorLog $APACHE_LOGS_DIRECTORY/$DOMAIN_NAME.error.log
    CustomLog $APACHE_LOGS_DIRECTORY/$DOMAIN_NAME.access.log combined
</VirtualHost>">/etc/apache2/sites-available/timi.conf
a2ensite timi.conf
#----------------------------------------------------
#APACHE SERVER RESTARTING
service apache2 restart
#---------------------------------------------------
#GIT CLONE THE APPLICATION SOURCE FILES AND INSTALLING
mkdir $APPLICATION_DIRECTORY/github
cd $APPLICATION_DIRECTORY/github
wget https://github.com/holding-it/timi/archive/master.zip
cd $APPLICATION_DIRECTORY
drush dl drupal-7 --drupal-project-rename=drupal
cp -avr $APPLICATION_DIRECTORY/drupal/* $APPLICATION_DIRECTORY/public_html
cp -avr $APPLICATION_DIRECTORY/drupal/.htaccess $APPLICATION_DIRECTORY/public_html
cp -avr $APPLICATION_DIRECTORY/drupal/.gitignore $APPLICATION_DIRECTORY/public_html
cd $APPLICATION_DIRECTORY/public_html
drush site-install standard --db-url='mysql://'$DATABASE_USER':'$DATABASE_PASSWORD'@'$DATABASE_HOST:$MYSQL_PORT'/'$DATABASE_NAME'' --site-name=$DOMAIN_NAME -y
if [ -d $APPLICATION_DIRECTORY/public_html/sites/default/files ]; then
    rm -rf $APPLICATION_DIRECTORY/public_html/sites/default/files
fi
if [ -d $APPLICATION_DIRECTORY/public_html/sites/all ]; then
    rm -rf $APPLICATION_DIRECTORY/public_html/sites/all
fi
drush sql-drop --database=default --yes
cd $APPLICATION_DIRECTORY/github
unzip $APPLICATION_DIRECTORY/github/master.zip
mysql -u$DATABASE_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_PASSWORD $DATABASE_NAME < $APPLICATION_DIRECTORY/github/timi-master/db/timi.sql
cp -avr $APPLICATION_DIRECTORY/github/timi-master/all $APPLICATION_DIRECTORY/public_html/sites
unzip $APPLICATION_DIRECTORY/public_html/sites/all/libraries.zip -d $APPLICATION_DIRECTORY/public_html/sites/all
rm $APPLICATION_DIRECTORY/public_html/sites/all/libraries.zip
unzip $APPLICATION_DIRECTORY/public_html/sites/all/modules.zip -d $APPLICATION_DIRECTORY/public_html/sites/all
rm $APPLICATION_DIRECTORY/public_html/sites/all/modules.zip
unzip $APPLICATION_DIRECTORY/public_html/sites/all/themes.zip -d $APPLICATION_DIRECTORY/public_html/sites/all
rm $APPLICATION_DIRECTORY/public_html/sites/all/themes.zip
cp -avr $APPLICATION_DIRECTORY/github/timi-master/files $APPLICATION_DIRECTORY/public_html/sites/default
unzip $APPLICATION_DIRECTORY/public_html/sites/default/files/files.zip -d $APPLICATION_DIRECTORY/public_html/sites/default
rm $APPLICATION_DIRECTORY/public_html/sites/default/files/files.zip
cp -avr $APPLICATION_DIRECTORY/github/timi-master/mob $APPLICATION_DIRECTORY/public_html
rm -rf $APPLICATION_DIRECTORY/github
rm -rf $APPLICATION_DIRECTORY/drupal
chmod 644 $APPLICATION_DIRECTORY/public_html/sites/default/settings.php
chown -R :www-data $APPLICATION_DIRECTORY/public_html/sites/default/files
chmod -R 775 $APPLICATION_DIRECTORY/public_html/sites/default/files
#---------------------------------------------------
#UPDATE THE APPLICATION DATABASE AND TRUNCATE THE CACHE TABLES
cd $APPLICATION_DIRECTORY/public_html
drush updb
