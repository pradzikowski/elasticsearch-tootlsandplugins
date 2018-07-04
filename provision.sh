rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

sudo yum install -y php71w-cli php71w-xml php71w-mbstring wget java-1.8.0-openjdk vim nodejs python34-setuptools nginx
sudo easy_install-3.4 pip

curl -Ss https://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.0.rpm
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.0.rpm.sha512
shasum -a 512 -c elasticsearch-6.3.0.rpm.sha512
sudo rpm --install elasticsearch-6.3.0.rpm
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo echo "http.cors.enabled: true" >> /etc/elasticsearch/elasticsearch.yml
sudo echo 'http.cors.allow-origin: "*"' >> /etc/elasticsearch/elasticsearch.yml
sudo service elasticsearch restart
sudo setsebool -P httpd_can_network_connect true

# Generate a Private Key
openssl genrsa -aes128 -out server.key 2048

sudo mkdir /etc/nginx/ssl
sudo sudo openssl req  -nodes -new -x509  -keyout /etc/nginx/ssl/ssl.key -out /etc/nginx/ssl/ssl.crt -subj "/C=FR/O=krkr/OU=Domain Control Validated/CN=*.krkr.io"
sudo setenforce permissive
sudo bash -c 'cat << EOF > /etc/nginx/conf.d/elastic.conf
server {
listen       8080 ssl;
ssl_certificate /etc/nginx/ssl/ssl.crt;
ssl_certificate_key /etc/nginx/ssl/ssl.key;
location / {
proxy_pass http://127.0.0.1:9200;
}
}

server {
listen       8081 ssl;
ssl_certificate /etc/nginx/ssl/ssl.crt;
ssl_certificate_key /etc/nginx/ssl/ssl.key;
location / {
proxy_pass http://127.0.0.1:9100;
}
}

server {
listen       8082 ssl;
ssl_certificate /etc/nginx/ssl/ssl.crt;
ssl_certificate_key /etc/nginx/ssl/ssl.key;
location / {
proxy_pass http://127.0.0.1:5000;
}
}
EOF'

sudo service nginx start

#install elasticsearch head
wget https://github.com/mobz/elasticsearch-head/archive/v5.0.0.tar.gz && tar -xvzf v5.0.0.tar.gz
cd /home/vagrant/elasticsearch-head-5.0.0 && sudo npm install && nohup npm run start &

#install cerebro
#wget https://github.com/lmenezes/cerebro/releases/download/v0.8.1/cerebro-0.8.1.tgz && tar -xvzf cerebro-0.8.1.tgz
#cd /home/vagrant/cerebro-0.8.1 && npm install && nohup bin/cerebro &

#install elasticsearch-HQ
wget https://github.com/ElasticHQ/elasticsearch-HQ/archive/v3.4.0.tar.gz && tar -xvzf v3.4.0.tar.gz
cd /home/vagrant/elasticsearch-HQ-3.4.0 && sudo pip3 install -r requirements.txt && nohup python3 application.py &

sleep 1m
cd /vagrant/php && composer install && php create_index.php && php fill_index.php

sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1