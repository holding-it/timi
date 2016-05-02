# TiMi
TiMi - Clean Miskolc mobile and web application, to be used as a public failure reporting system, enables citizens to report local problems such as illegal trash dumping, non-working street lights, broken tiles on sidewalks and illegal advertising boards.

# Installation procedure

sudo apt-get update

sudo apt-get install php5-cli -y<br>
sudo apt-get install php5-gd -y<br>
sudo apt-get install php5-curl -y<br>
sudo apt-get install libssh2-php -y<br>
sudo apt-get install 7zip unzip -y<br>
sudo apt-get install drush -y<br>

# Create database
sudo mysql -u root -p<br>
CREATE DATABASE timi;<br>
CREATE USER timi@localhost IDENTIFIED BY '[your password]';<br>
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,INDEX,ALTER,CREATE TEMPORARY TABLES,LOCK TABLES ON timi.* TO timi@localhost;<br>
FLUSH PRIVILEGES;<br>
exit<br>

# Add the following lines to the php.ini file<br>
sudo nano /etc/php5/apache2/php.ini<br>

expose_php = Off<br>
allow_url_fopen = Off<br>
max_execution_time = 300<br>
memory_limit = 256M<br>
display_errors = Off<br>
session.cache_limiter = nocache<br>
session.auto_start = 0<br>
magic_quotes_gpc = off<br>
register_globals = off<br>

sudo a2enmod rewrite<br>

sudo mkdir -p /var/www/timi/public_html<br>
sudo chown -R $USER:$USER /var/www/timi/public_html<br>
sudo chmod -R 755 /var/www/timi<br>

# Create Virtual Host<br>
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/timi.conf<br>
sudo nano /etc/apache2/sites-enabled/timi.conf<br>

<VirtualHost *:80>
	ServerAdmin admin@test.com
	ServerName  example.com
	ServerAlias www.example.com
	DocumentRoot /var/www/timi/public_html
		<Directory /var/www/timi/public_html>
			AllowOverride All
		</Directory>
		ErrorLog ${APACHE_LOG_DIR}/timi.error.log
		CustomLog ${APACHE_LOG_DIR}/timi.access.log combined
</VirtualHost>

sudo a2ensite timi.conf

sudo service apache2 restart

sudo mkdir -p /var/www/timi/github
sudo cd /var/www/timi/github
sudo wget https://github.com/timi/archive/timi.zip
sudo cd /var/www/timi
sudo drush dl drupal-7 --drupal-project-rename=drupal
sudo cp var/www/timi/drupal/* var/www/timi/public_html
sudo cd /var/www/timi/public_html drush site-install standard --db-url='mysql://timi:[db_pass]@localhost/timi' --site-name=Timi
sudo rm /var/www/timi/public_html/sites/default/files
sudo rm /var/www/timi/public_html/sites/all
sudo cd /var/www/timi/github
sudo unzip timi.zip
sudo mysql -uroot -p timi<timi.sql
sudo cp var/www/timi/github/all var/www/timi/public_html/sites
sudo cp var/www/timi/github/files var/www/timi/public_html/sites/default
sudo cp var/www/timi/github/mob var/www/timi/public_html
sudo rm /var/www/timi/github
sudo rm /var/www/timi/drupal

sudo chmod 644 /var/www/timi/public_html/sites/default/settings.php
sudo chown -R :www-data /var/www/timi/public_html/sites/default/files
sudo chmod -R 775 /var/www/timi/public_html/sites/default/files

sudo cd /var/www/timi/public_html
sudo drush updb -y
sudo drush cc all -y
