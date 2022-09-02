#!/bin/sh

sudo apt-get update

sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo docker run hello-world
sudo systemctl status docker

sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.11.1
sudo docker ps

echo Итак, немного настроек
echo
echo Введите имя домена, на котором ваш Nightscout будет доступен:
read domain
echo "NS_DOMAIN=$domain" >> .env
echo
echo
echo Придумайте и введите APIsecret ключ, 12 символов буквы и цифры:
read secret
echo echo "NS_SECRET=$secret" >> .env
echo
echo
echo Введите название Вашей сттраницы Nightscout:
read title
echo echo "NS_TITLE=$title" >> .env
echo




curl https://raw.githubusercontent.com/mo211073bkp/ns-justmara/main/docker-compose.yml --output docker-compose.yml
sudo docker compose up -d

echo "Ваш секретный ключ для доступа к Nightscout (запишите!):"
echo "secret: $secret"
echo "Адрес Вашего Nightscout (запишите!):"
echo "domain: $domain"
