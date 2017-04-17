#!/bin/bash

while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
   sleep 40
done
sudo apt-get install -y nginx php7.0-fpm php7.0-cli php7.0-gd php7.0-mysql php7.0-xml php7.0-curl git drush
sudo apt-get install -y mariadb-client mariadb-server
sudo sed -i 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g' /etc/php/7.0/fpm/php.ini
cd /var/www
sudo drush dl drupal-7
mv drupal* drupal7
cd drupal7/sites/default
cp default.settings.php settings.php
sudo mkdir -p files/private
sudo chmod a+w *
sudo chown -R www-data:www-data /var/www
sudo rm -rf /etc/nginx/sites-available/default
sudo cp /tmp/drupal7 /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/drupal7 /etc/nginx/sites-enabled/drupal7
sudo cp -r /tmp/ssl /etc/nginx
sudo cp /tmp/nginx.conf /etc/nginx/nginx.conf
sudo systemctl restart nginx
sudo systemctl restart php7.0-fpm
sudo chmod 600 /etc/nginx/drupal.key
sudo rm -rf /tmp/nginx.conf
sudo rm -rf /tmp/drupal7
sudo rm -rf /tmp/ssl
 
#setup dbs

PASS='mysqlp@$$'
DB1=drupal
DB2=cvicrm
DBUSER=dbuser
mysql -uroot <<MYSQL_SCRIPT
CREATE DATABASE $DB1;
CREATE DATABASE $DB2;
CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL PRIVILEGES ON $DB1.* TO '$DBUSER'@'localhost';
GRANT ALL PRIVILEGES ON $DB2.* TO '$DBUSER'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
