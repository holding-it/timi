# TiMi
TiMi - Clean Miskolc mobile and web application, to be used as a public failure reporting system, enables citizens to report local problems such as illegal trash dumping, non-working street lights, broken tiles on sidewalks and illegal advertising boards.

#Installation procedure

sudo apt-get update

sudo apt-get install php5-cli -y<br>
sudo apt-get install php5-gd -y<br>
sudo apt-get install php5-curl -y<br>
sudo apt-get install libssh2-php -y<br>
sudo apt-get install 7zip unzip -y<br>
sudo apt-get install drush -y<br>

sudo mysql -u root -p<br>
CREATE DATABASE timi;<br>
CREATE USER timi@localhost IDENTIFIED BY '******';<br>
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,INDEX,ALTER,CREATE TEMPORARY TABLES,LOCK TABLES ON timi.* TO timi@localhost;<br>
FLUSH PRIVILEGES;<br>
exit<br>

# Add the following lines to the php.ini file
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

sudo a2enmod rewrite

sudo mkdir -p /var/www/timi/public_html<br>
sudo chown -R $USER:$USER /var/www/timi/public_html<br>
sudo chmod -R 755 /var/www/timi<br>

# Create Virtual Host
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/timi.conf<br>
sudo nano /etc/apache2/sites-enabled/timi.conf<br>

<VirtualHost *:80><br>
  ServerAdmin admin@test.com<br>
  ServerName  example.com<br>
  ServerAlias www.example.com<br>
  DocumentRoot /var/www/timi/public_html<br>
  <Directory /var/www/timi/public_html><br>
                   AllowOverride All<br>
  </Directory><br>
  ErrorLog ${APACHE_LOG_DIR}/timi.error.log<br>
  CustomLog ${APACHE_LOG_DIR}/timi.access.log combined<br>
</VirtualHost><br>

sudo a2ensite timi.conf<br>

sudo service apache2 restart

sudo mkdir -p /var/www/timi/github<br>
sudo cd /var/www/timi/github<br>
sudo wget https://github.com/timi/archive/timi.zip<br>
sudo cd /var/www/timi<br>
sudo drush dl drupal-7 --drupal-project-rename=drupal<br>
sudo cp var/www/timi/drupal/* var/www/timi/public_html<br>
sudo cd /var/www/timi/public_html drush site-install standard --db-url='mysql://timi:[db_pass]@localhost/timi' --site-name=Timi<br>
sudo rm /var/www/timi/public_html/sites/default/files<br>
sudo rm /var/www/timi/public_html/sites/all<br>
sudo cd /var/www/timi/github<br>
sudo unzip timi.zip<br>
sudo mysql -uroot -p timi<timi.sql<br>
sudo cp var/www/timi/github/all var/www/timi/public_html/sites<br>
sudo cp var/www/timi/github/files var/www/timi/public_html/sites/default<br>
sudo cp var/www/timi/github/mob var/www/timi/public_html<br>
sudo rm /var/www/timi/github<br>
sudo rm /var/www/timi/drupal<br>

sudo chmod 644 /var/www/timi/public_html/sites/default/settings.php<br>
sudo chown -R :www-data /var/www/timi/public_html/sites/default/files<br>
sudo chmod -R 775 /var/www/timi/public_html/sites/default/files<br>

sudo cd /var/www/timi/public_html<br>
sudo drush updb -y<br>
sudo drush cc all -y<br>

