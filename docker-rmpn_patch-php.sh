sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
apk update

apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev autoconf gcc g++ make libffi-dev openssl-dev
docker-php-ext-configure gd --with-freetype --with-jpeg
docker-php-ext-install gd

apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

docker-php-ext-install pdo pdo_mysql

pecl install igbinary && docker-php-ext-enable igbinary
pecl install redis-5.3.1 && docker-php-ext-enable redis

apk add supervisor
mkdir -p /etc/supervisord.d && mkdir -p /var/log/supervisor

apk add vim
