#!/bin/bash
#SYSTEM REQUIREMENTS: Ubuntu 14.04 LTS SERVER 64 bit
#SET VARIABLES
#APACHE PORT
export APACHE_PORT=80
#APACHE LOGS FOLDER
export APACHE_LOGS_DIRECTORY="/var/log/apache2"
#REMOTE MYSQL SERVER PORT (CHANGE IF NOT DEFAULT)
export MYSQL_PORT=3306
#REMOTE MYSQL SERVER IP ADDRESS
export DATABASE_HOST="10.20.0.10"
#REMOTE SERVER MYSQL USER
export DATABASE_ADMIN_USER="miskolc"
#REMOTE SERVER MYSQL PASSWORD
export DATABASE_ADMIN_PASSWORD="F4UXoIm1yGUHxTIv"
#MYSQL USER FOR THE APPLICATION
export DATABASE_USER="timi"
#MYSQL PASSWORD FOR THE APPLICATION
export DATABASE_PASSWORD="xxxxxx"
#DATABASE NAME FOR THE APPLICATION
export DATABASE_NAME="timi"
#SERVER ADMIN E-MAIL ADDRESS FOR VIRTUALHOST
export SERVER_ADMIN_MAIL="admin@test.com"
#DOMAIN NAME FOR THE APPLICATION
export DOMAIN_NAME="timi.miskolc.hu"
#WEBSITE NAME (this name will be set the for the website name)
export SITENAME="Timi"
#THE APPLICATION NAME
export APPLICATION_NAME="timi"
#THE APPLICATION FOLDER IN VAR/WWW
export APPLICATION_DIRECTORY="/var/www/$APPLICATION_NAME"
#OR /var/www/html/$APPLICATION_NAME
#----------------------------------------------------
#INSTALLING THE NECESSARY PACKAGES
apt-get update
apt-get install apache2 -y
apt-get install php5 -y
apt-get install libapache2-mod-php5 -y
apt-get install mysql-client -y
apt-get install php5-mcrypt -y
apt-get install php5-mysql -y
apt-get install php5-cli -y
apt-get install php5-gd -y
apt-get install php5-curl -y
apt-get install libssh2-php -y
apt-get install unzip -y
apt-get install drush -y
#----------------------------------------------------
#CREATE THE DATABASE AND THE DATABASE USER ON THE REMOTE HOST TO THE APPLICATION
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "DROP DATABASE IF EXISTS $DATABASE_NAME;"
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "CREATE DATABASE $DATABASE_NAME;"
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "DROP USER $DATABASE_USER@'%';"
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "FLUSH PRIVILEGES;"
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "CREATE USER $DATABASE_USER@'%' IDENTIFIED BY '$DATABASE_PASSWORD';"
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,INDEX,ALTER,CREATE TEMPORARY TABLES,LOCK TABLES ON $DATABASE_NAME.* TO $DATABASE_USER@'%';"
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD -e "FLUSH PRIVILEGES;"
#----------------------------------------------------
#UPDATE PHP.INI IF NECESSARY
#GET THE CURRENT OPTIONS
PHP_MEMORY_LIMIT="$(sed -ne '/^memory_limit/s/[^0-9]//gp' /etc/php5/apache2/php.ini)"
PHP_MAX_EXECUTION_TIME="$(sed -ne '/^max_execution_time/s/[^0-9]//gp' /etc/php5/apache2/php.ini)"
PHP_POST_MAX_SIZE="$(sed -ne '/^post_max_size/s/[^0-9]//gp' /etc/php5/apache2/php.ini)"
PHP_UPLOAD_MAX_FILESIZE="$(sed -ne '/^upload_max_filesize/s/[^0-9]//gp' /etc/php5/apache2/php.ini)"
#THESE SETTINGS ARE NECESSARY FOR THE RIGHT FUNCTIONING
#CHANGE PHP_MEMORY_LIMIT IF LESS THAN 256M
if [ "$PHP_MEMORY_LIMIT" -lt 256 ]; then
sed -i '/memory_limit/c\memory_limit = 256M' /etc/php5/apache2/php.ini
fi
#CHANGE PHP_MAX_EXECUTION_TIME IF LESS THAN 300s 
if [ "$PHP_MAX_EXECUTION_TIME" -lt 300 ]; then
sed -i '/max_execution_time/c\max_execution_time = 300' /etc/php5/apache2/php.ini
fi
#CHANGE PHP_POST_MAX_SIZE IF LESS THAN 16M
if [ "$PHP_POST_MAX_SIZE" -lt 16 ]; then
sed -i '/post_max_size/c\post_max_size = 16M' /etc/php5/apache2/php.ini
fi
#CHANGE UPLOAD_MAX_FILESIZE IF LESS THAN 16M
if [ "$PHP_UPLOAD_MAX_FILESIZE" -lt 16 ]; then
sed -i '/upload_max_filesize/c\upload_max_filesize = 16M' /etc/php5/apache2/php.ini
fi
#----------------------------------------------------
#APACHE REWRITE ENABLE
a2enmod rewrite
#----------------------------------------------------
#CREATE THE DIRECTORY STRUCTURE
#FIRST REMOVE THE PREVIOUS DIRECTORY STRUCTURE IF EXISTS
if [ -d $APPLICATION_DIRECTORY ]; then
rm -rf $APPLICATION_DIRECTORY
fi
mkdir -p $APPLICATION_DIRECTORY/public_html
chown -R $USER:$USER $APPLICATION_DIRECTORY/public_html
chmod -R 755 $APPLICATION_DIRECTORY
#----------------------------------------------------
#CREATE AND ENABLE VIRTUAL HOST
#FIRST REMOVE THE PREVIOUS SETTINGS IF EXISTS
if [ -e /etc/apache2/sites-available/$APPLICATION_NAME.conf ]; then
a2dissite $APPLICATION_NAME.conf
rm -rf /etc/apache2/sites-available/$APPLICATION_NAME.conf
fi
#THEN CREATE A NEW ONE WITH THE SPECIFIED PARAMETERS
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$APPLICATION_NAME.conf
echo "
<VirtualHost *:80>
	ServerAdmin $SERVER_ADMIN_MAIL
	ServerName  $DOMAIN_NAME
	ServerAlias www.$DOMAIN_NAME
	DocumentRoot $APPLICATION_DIRECTORY/public_html

	<Directory $APPLICATION_DIRECTORY/public_html>
		AllowOverride All
	</Directory>

	ErrorLog $APACHE_LOGS_DIRECTORY/$DOMAIN_NAME.error.log
	CustomLog $APACHE_LOGS_DIRECTORY/$DOMAIN_NAME.access.log combined
</VirtualHost>
">/etc/apache2/sites-available/$APPLICATION_NAME.conf
#THEN ENABLE THE NEWLY CREATED VIRTUAL HOST
a2ensite $APPLICATION_NAME.conf
#----------------------------------------------------
#APACHE SERVER RESTARTING
service apache2 restart
#---------------------------------------------------
#GIT CLONE THE APPLICATION SOURCE FILES AND INSTALLING
mkdir $APPLICATION_DIRECTORY/github
cd $APPLICATION_DIRECTORY/github
#DOWNLOAD THE APPLICITAION NECCESSERY FILES FROM GITHUB TO THE GITHUB SUBFOLDER(temporary folder)
wget https://github.com/holding-it/timi/archive/master.zip
cd $APPLICATION_DIRECTORY
#DOWNLOAD THE LATEST DRUPAL 7 CORE FILES IN THE DRUPAL SUBFOLDER(temporary folder) WITH DRUSH(Drush is a command-line shell and scripting interface for Drupal)
drush dl drupal-7 --drupal-project-rename=drupal
#COPY ALL FILES FROM DRUPAL SUBFOLDER TO THE APPLICATION FINAL FOLDER(public_html)
cp -avr $APPLICATION_DIRECTORY/drupal/* $APPLICATION_DIRECTORY/public_html
cp -avr $APPLICATION_DIRECTORY/drupal/.htaccess $APPLICATION_DIRECTORY/public_html
cp -avr $APPLICATION_DIRECTORY/drupal/.gitignore $APPLICATION_DIRECTORY/public_html
cd $APPLICATION_DIRECTORY/public_html
#INSTALLING THE NEW DRUPAL 7 AND CREATE THE DATABASE CONNECTION(with the specified parameters) AUTOMATICLY WITH DRUS (Drush is a command-line shell and scripting interface for Drupal https://github.com/drush-ops/drush)
drush site-install standard --db-url='mysql://'$DATABASE_USER':'$DATABASE_PASSWORD'@'$DATABASE_HOST:$MYSQL_PORT'/'$DATABASE_NAME'' --site-name=$SITENAME --yes
#REMOVE THE UNNECESSARY FILES AND FOLDERS IF EXISTS
if [ -d $APPLICATION_DIRECTORY/public_html/sites/default/files ]; then
rm -rf $APPLICATION_DIRECTORY/public_html/sites/default/files
fi
if [ -d $APPLICATION_DIRECTORY/public_html/sites/all ]; then
rm -rf $APPLICATION_DIRECTORY/public_html/sites/all
fi
#DROP ALL TABLES FROM THE NEWLY CREATED DRUPAL DATABASE WICH IS CURRENTLY EMPTY ANYWAY(It's not contains data)
#THIS STEP IS NECESSARY TO BE ABLE TO THE APPLICATION DATABASE SHOULD BE IMPORTED SAFELY
drush sql-drop --database=default --yes
#UNZIP AND COPY THE FINAL PLACE THE APPLICATION FILES AND FOLDERS THAN REMOVE THE UNNECESSARY THINGS
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
#SET THE NECESSARY FOLDER AND FILE PERMISSIONS
chmod 644 $APPLICATION_DIRECTORY/public_html/sites/default/settings.php
chown -R :www-data $APPLICATION_DIRECTORY/public_html/sites/default/files
chmod -R 775 $APPLICATION_DIRECTORY/public_html/sites/default/files
#---------------------------------------------------
#UPDATE THE APPLICATION DATABASE AND TRUNCATE THE CACHE TABLES WITH DRUSH
cd $APPLICATION_DIRECTORY/public_html
drush updb --yes
#TURN OFF THE APPLICATION MAINTENANCE MODE WITH DRUSH
drush vset maintenance_mode 0 --yes