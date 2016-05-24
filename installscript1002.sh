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
#DATABASE NAME FOR THE APPLICATION
export DATABASE_NAME="miskolc_...timi"

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

mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD << _EOF_
USE $DATABASE_NAME;
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS actions;
DROP TABLE IF EXISTS app_alkat_groups;
DROP TABLE IF EXISTS app_glob;
DROP TABLE IF EXISTS app_kods;
DROP TABLE IF EXISTS app_nevjegy;
DROP TABLE IF EXISTS app_stat_groups;
DROP TABLE IF EXISTS authmap;
DROP TABLE IF EXISTS batch;
DROP TABLE IF EXISTS block;
DROP TABLE IF EXISTS block_custom;
DROP TABLE IF EXISTS block_node_type;
DROP TABLE IF EXISTS block_role;
DROP TABLE IF EXISTS blocked_ips;
DROP TABLE IF EXISTS cache;
DROP TABLE IF EXISTS cache_admin_menu;
DROP TABLE IF EXISTS cache_block;
DROP TABLE IF EXISTS cache_bootstrap;
DROP TABLE IF EXISTS cache_entity_message;
DROP TABLE IF EXISTS cache_entity_message_type;
DROP TABLE IF EXISTS cache_entity_message_type_category;
DROP TABLE IF EXISTS cache_feeds_http;
DROP TABLE IF EXISTS cache_field;
DROP TABLE IF EXISTS cache_filter;
DROP TABLE IF EXISTS cache_form;
DROP TABLE IF EXISTS cache_geocoder;
DROP TABLE IF EXISTS cache_image;
DROP TABLE IF EXISTS cache_l10n_update;
DROP TABLE IF EXISTS cache_libraries;
DROP TABLE IF EXISTS cache_menu;
DROP TABLE IF EXISTS cache_metatag;
DROP TABLE IF EXISTS cache_page;
DROP TABLE IF EXISTS cache_path;
DROP TABLE IF EXISTS cache_rules;
DROP TABLE IF EXISTS cache_token;
DROP TABLE IF EXISTS cache_update;
DROP TABLE IF EXISTS cache_variable;
DROP TABLE IF EXISTS cache_views;
DROP TABLE IF EXISTS cache_views_data;
DROP TABLE IF EXISTS ckeditor_input_format;
DROP TABLE IF EXISTS ckeditor_settings;
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS contact;
DROP TABLE IF EXISTS ctools_css_cache;
DROP TABLE IF EXISTS ctools_object_cache;
DROP TABLE IF EXISTS date_format_locale;
DROP TABLE IF EXISTS date_format_type;
DROP TABLE IF EXISTS date_formats;
DROP TABLE IF EXISTS fboauth_users;
DROP TABLE IF EXISTS feeds_importer;
DROP TABLE IF EXISTS feeds_item;
DROP TABLE IF EXISTS feeds_log;
DROP TABLE IF EXISTS feeds_push_subscriptions;
DROP TABLE IF EXISTS feeds_source;
DROP TABLE IF EXISTS field_collection_item;
DROP TABLE IF EXISTS field_collection_item_revision;
DROP TABLE IF EXISTS field_config;
DROP TABLE IF EXISTS field_config_instance;
DROP TABLE IF EXISTS field_data_body;
DROP TABLE IF EXISTS field_data_comment_body;
DROP TABLE IF EXISTS field_data_endpoints;
DROP TABLE IF EXISTS field_data_field_coordinates;
DROP TABLE IF EXISTS field_data_field_date;
DROP TABLE IF EXISTS field_data_field_deleted_description;
DROP TABLE IF EXISTS field_data_field_deleted_nid;
DROP TABLE IF EXISTS field_data_field_deleted_rejection_id;
DROP TABLE IF EXISTS field_data_field_deleted_title;
DROP TABLE IF EXISTS field_data_field_description;
DROP TABLE IF EXISTS field_data_field_description_language;
DROP TABLE IF EXISTS field_data_field_fullname;
DROP TABLE IF EXISTS field_data_field_group_description;
DROP TABLE IF EXISTS field_data_field_image;
DROP TABLE IF EXISTS field_data_field_imagelink;
DROP TABLE IF EXISTS field_data_field_inactive;
DROP TABLE IF EXISTS field_data_field_language;
DROP TABLE IF EXISTS field_data_field_mapbound;
DROP TABLE IF EXISTS field_data_field_new_relation_id;
DROP TABLE IF EXISTS field_data_field_new_status_id;
DROP TABLE IF EXISTS field_data_field_new_subcategory_id;
DROP TABLE IF EXISTS field_data_field_node_nid;
DROP TABLE IF EXISTS field_data_field_node_title;
DROP TABLE IF EXISTS field_data_field_only_images;
DROP TABLE IF EXISTS field_data_field_owner_id_number;
DROP TABLE IF EXISTS field_data_field_place;
DROP TABLE IF EXISTS field_data_field_public;
DROP TABLE IF EXISTS field_data_field_status;
DROP TABLE IF EXISTS field_data_field_subcategory;
DROP TABLE IF EXISTS field_data_field_tags;
DROP TABLE IF EXISTS field_data_field_ticket_id;
DROP TABLE IF EXISTS field_data_field_ticketgroup;
DROP TABLE IF EXISTS field_data_field_ticketgroup_id;
DROP TABLE IF EXISTS field_data_field_ticketgroup_page;
DROP TABLE IF EXISTS field_data_field_ticketimage;
DROP TABLE IF EXISTS field_data_field_tickets;
DROP TABLE IF EXISTS field_data_field_timi_password;
DROP TABLE IF EXISTS field_data_field_view;
DROP TABLE IF EXISTS field_data_message_text;
DROP TABLE IF EXISTS field_revision_body;
DROP TABLE IF EXISTS field_revision_comment_body;
DROP TABLE IF EXISTS field_revision_endpoints;
DROP TABLE IF EXISTS field_revision_field_coordinates;
DROP TABLE IF EXISTS field_revision_field_date;
DROP TABLE IF EXISTS field_revision_field_deleted_description;
DROP TABLE IF EXISTS field_revision_field_deleted_nid;
DROP TABLE IF EXISTS field_revision_field_deleted_rejection_id;
DROP TABLE IF EXISTS field_revision_field_deleted_title;
DROP TABLE IF EXISTS field_revision_field_description;
DROP TABLE IF EXISTS field_revision_field_description_language;
DROP TABLE IF EXISTS field_revision_field_fullname;
DROP TABLE IF EXISTS field_revision_field_group_description;
DROP TABLE IF EXISTS field_revision_field_image;
DROP TABLE IF EXISTS field_revision_field_imagelink;
DROP TABLE IF EXISTS field_revision_field_inactive;
DROP TABLE IF EXISTS field_revision_field_language;
DROP TABLE IF EXISTS field_revision_field_mapbound;
DROP TABLE IF EXISTS field_revision_field_new_relation_id;
DROP TABLE IF EXISTS field_revision_field_new_status_id;
DROP TABLE IF EXISTS field_revision_field_new_subcategory_id;
DROP TABLE IF EXISTS field_revision_field_node_nid;
DROP TABLE IF EXISTS field_revision_field_node_title;
DROP TABLE IF EXISTS field_revision_field_only_images;
DROP TABLE IF EXISTS field_revision_field_owner_id_number;
DROP TABLE IF EXISTS field_revision_field_place;
DROP TABLE IF EXISTS field_revision_field_public;
DROP TABLE IF EXISTS field_revision_field_status;
DROP TABLE IF EXISTS field_revision_field_subcategory;
DROP TABLE IF EXISTS field_revision_field_tags;
DROP TABLE IF EXISTS field_revision_field_ticket_id;
DROP TABLE IF EXISTS field_revision_field_ticketgroup;
DROP TABLE IF EXISTS field_revision_field_ticketgroup_id;
DROP TABLE IF EXISTS field_revision_field_ticketgroup_page;
DROP TABLE IF EXISTS field_revision_field_ticketimage;
DROP TABLE IF EXISTS field_revision_field_tickets;
DROP TABLE IF EXISTS field_revision_field_timi_password;
DROP TABLE IF EXISTS field_revision_field_view;
DROP TABLE IF EXISTS field_revision_message_text;
DROP TABLE IF EXISTS file_managed;
DROP TABLE IF EXISTS file_usage;
DROP TABLE IF EXISTS filter;
DROP TABLE IF EXISTS filter_format;
DROP TABLE IF EXISTS flood;
DROP TABLE IF EXISTS history;
DROP TABLE IF EXISTS i18n_block_language;
DROP TABLE IF EXISTS i18n_path;
DROP TABLE IF EXISTS i18n_string;
DROP TABLE IF EXISTS i18n_translation_set;
DROP TABLE IF EXISTS image_effects;
DROP TABLE IF EXISTS image_styles;
DROP TABLE IF EXISTS job_schedule;
DROP TABLE IF EXISTS l10n_update_file;
DROP TABLE IF EXISTS l10n_update_project;
DROP TABLE IF EXISTS languages;
DROP TABLE IF EXISTS locales_source;
DROP TABLE IF EXISTS locales_target;
DROP TABLE IF EXISTS menu_custom;
DROP TABLE IF EXISTS menu_links;
DROP TABLE IF EXISTS menu_router;
DROP TABLE IF EXISTS message;
DROP TABLE IF EXISTS message_type;
DROP TABLE IF EXISTS message_type_category;
DROP TABLE IF EXISTS metatag;
DROP TABLE IF EXISTS metatag_config;
DROP TABLE IF EXISTS mob_categories;
DROP TABLE IF EXISTS mob_contents;
DROP TABLE IF EXISTS mob_languages;
DROP TABLE IF EXISTS mob_owners;
DROP TABLE IF EXISTS mob_pictures;
DROP TABLE IF EXISTS mob_statuses;
DROP TABLE IF EXISTS mob_statuslogs;
DROP TABLE IF EXISTS mob_subcategories;
DROP TABLE IF EXISTS mob_ticketgroups;
DROP TABLE IF EXISTS mob_tickets;
DROP TABLE IF EXISTS node;
DROP TABLE IF EXISTS node_access;
DROP TABLE IF EXISTS node_comment_statistics;
DROP TABLE IF EXISTS node_revision;
DROP TABLE IF EXISTS node_type;
DROP TABLE IF EXISTS openlayers_layers;
DROP TABLE IF EXISTS openlayers_maps;
DROP TABLE IF EXISTS openlayers_projections;
DROP TABLE IF EXISTS openlayers_styles;
DROP TABLE IF EXISTS pathauto_state;
DROP TABLE IF EXISTS queue;
DROP TABLE IF EXISTS rdf_mapping;
DROP TABLE IF EXISTS registry;
DROP TABLE IF EXISTS registry_file;
DROP TABLE IF EXISTS relation;
DROP TABLE IF EXISTS relation_bundles;
DROP TABLE IF EXISTS relation_revision;
DROP TABLE IF EXISTS relation_type;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS role_permission;
DROP TABLE IF EXISTS rules_config;
DROP TABLE IF EXISTS rules_dependencies;
DROP TABLE IF EXISTS rules_tags;
DROP TABLE IF EXISTS rules_trigger;
DROP TABLE IF EXISTS search_dataset;
DROP TABLE IF EXISTS search_index;
DROP TABLE IF EXISTS search_node_links;
DROP TABLE IF EXISTS search_total;
DROP TABLE IF EXISTS sec_apps;
DROP TABLE IF EXISTS sec_groups;
DROP TABLE IF EXISTS sec_groups_apps;
DROP TABLE IF EXISTS sec_users;
DROP TABLE IF EXISTS sec_users_groups;
DROP TABLE IF EXISTS semaphore;
DROP TABLE IF EXISTS sequences;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS shortcut_set;
DROP TABLE IF EXISTS shortcut_set_users;
DROP TABLE IF EXISTS system;
DROP TABLE IF EXISTS taxonomy_index;
DROP TABLE IF EXISTS taxonomy_term_data;
DROP TABLE IF EXISTS taxonomy_term_hierarchy;
DROP TABLE IF EXISTS taxonomy_vocabulary;
DROP TABLE IF EXISTS url_alias;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS users_roles;
DROP TABLE IF EXISTS variable;
DROP TABLE IF EXISTS variable_store;
DROP TABLE IF EXISTS views_display;
DROP TABLE IF EXISTS views_view;
DROP TABLE IF EXISTS watchdog;
DROP TABLE IF EXISTS webform;
DROP TABLE IF EXISTS webform_component;
DROP TABLE IF EXISTS webform_conditional;
DROP TABLE IF EXISTS webform_conditional_actions;
DROP TABLE IF EXISTS webform_conditional_rules;
DROP TABLE IF EXISTS webform_emails;
DROP TABLE IF EXISTS webform_last_download;
DROP TABLE IF EXISTS webform_roles;
DROP TABLE IF EXISTS webform_submissions;
DROP TABLE IF EXISTS webform_submitted_data;
DROP TABLE IF EXISTS zzz_proba;
SET FOREIGN_KEY_CHECKS=1;

exit
_EOF_


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
drush site-install standard --db-url='mysql://'$DATABASE_ADMIN_USER':'$DATABASE_ADMIN_PASSWORD'@'$DATABASE_HOST:$MYSQL_PORT'/'$DATABASE_NAME'' --site-name=$SITENAME --yes
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
mysql -u$DATABASE_ADMIN_USER -h$DATABASE_HOST -P$MYSQL_PORT -p$DATABASE_ADMIN_PASSWORD $DATABASE_NAME < $APPLICATION_DIRECTORY/github/timi-master/db/timi.sql
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
