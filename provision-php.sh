#!/bin/bash

sudo apt-get update -y

# Long process to do dist upgrades noninteractively...
#export DEBIAN_FRONTEND=noninteractive
#unset UCF_FORCE_CONFFOLD
#export UCF_FORCE_CONFFNEW=YES
#sudo ucf --purge /boot/grub/menu.lst
#sudo apt-get -y -o Dpkg::Options::="--force-confnew" --allow-downgrades --allow-remove-essential --allow-change-held-packages -fuy dist-upgrade

#sudo apt-get install -y linux-headers-`uname -r`
sudo apt-get install -y build-essential curl wget zip unzip g++ gcc git nginx

sudo apt-get install -y python-software-properties software-properties-common
LC_ALL=C.UTF-8 sudo add-apt-repository ppa:ondrej/php
sudo apt-get update -y
sudo apt-get install -y php7.1 php7.1-common php7.1-cli php7.1-fpm php7.1-mysql php7.1-mcrypt php7.1-gd php7.1-mbstring php7.1-xml php7.1-xmlrpc php7.1-curl php7.1-json php7.1-zip php7.1-bcmath php7.1-dev

sudo apt-get install -y postgresql
sudo -u postgres psql -c "ALTER USER postgres WITH ENCRYPTED PASSWORD 'postgres'"
echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/9.5/main/pg_hba.conf 
echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/9.5/main/postgresql.conf

# sudo apt-get install -y redis-server
# git clone https://github.com/phpredis/phpredis.git
# cd phpredis
# phpize
# ./configure
# make && sudo make install
# cd ~

wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
echo "deb http://www.rabbitmq.com/debian/ testing main" | sudo tee -a /etc/apt/sources.list.d/rabbitmq.list
sudo apt-get update -y
sudo apt-get install -y rabbitmq-server
sudo rabbitmq-plugins enable rabbitmq_management

sudo touch /etc/rabbitmq/rabbitmq.config
echo "[{rabbit, [{loopback_users, []}]}]." | sudo tee -a /etc/rabbitmq/rabbitmq.config

sudo apt-get --purge autoremove -y

EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")
if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm -f composer-setup.php
    exit 1
fi
php composer-setup.php --quiet
rm composer-setup.php
sudo mv composer.phar /usr/local/bin/composer

sudo rm -rf /var/www/html/*
cd /var/www/html
sudo cp -R /vagrant/server/php/* .
sudo composer install

sudo usermod -a -G vagrant www-data
sudo chown -R www-data:www-data /var/www/html

sudo rm -rf /etc/nginx/sites-available/*
sudo rm -rf /etc/nginx/sites-enabled/*
sudo touch /etc/nginx/sites-available/php
sudo bash -c "cat > /etc/nginx/sites-available/php" << EOF
server {
	server_tokens off;
	listen 80 default_server;
	
	server_name php.dev;
	root /var/www/html;
	index index.php index.html main.php;
	
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        try_files \$uri /index.php =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

sudo ln -fs /etc/nginx/sites-available/php /etc/nginx/sites-enabled/

sudo bash -c "echo 'cgi.fix_pathinfo=0' >> /etc/php/7.1/fpm/php.ini"

sudo service php7.1-fpm restart
sudo service nginx restart
sudo service rabbitmq-server restart
sudo service postgresql restart