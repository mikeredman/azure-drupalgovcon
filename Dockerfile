#------------------------------------------------------------------------------
# PHP BASE
#------------------------------------------------------------------------------
    FROM drupal:8.7.8-fpm-alpine as php-prod

    # Set timezone.
    ENV PHP_TIMEZONE America/New_York
    RUN echo "date.timezone = \"$PHP_TIMEZONE\"" > /usr/local/etc/php/conf.d/timezone.ini
    
    RUN cat /dev/urandom | LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1 > /var/www/salt.txt
    
    WORKDIR /var/www
    
    RUN apk add --no-cache --virtual .build-deps \
                 # Misc dependencies
                 autoconf \
                 g++ \
                 pcre-dev \
                 libtool \
                 make \
                 curl \
                 git \
                 # Needed base depend
                 coreutils
    RUN apk add --no-cache --update mysql-client
    
    # install the PHP extensions we need
    RUN set -ex \
      && apk add --no-cache --virtual .build-php-exts \
                 # GD depends
                 freetype-dev \
                 libjpeg-turbo-dev \
                 libpng-dev \
                 # xmlrpc depends
                 libxml2-dev \
                 libxslt-dev \
                 libzip-dev \
                 # ftp depends
                 openssl-dev \
      # Configure and Install PHP extensions
      && docker-php-ext-configure gd  \
           --with-freetype=/usr/include/ \
           --with-jpeg=/usr/include/ \
           #--with-png=/usr/include/ \
      && docker-php-ext-install -j "$(nproc)" \
                 gd \
                 mysqli \
                 opcache \
                 pdo_mysql \
                 xsl \
                 zip \
                 ftp \
                 fileinfo \
      && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
          | tr ',' '\n' \
          | sort -u \
          | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
      )" \
      && apk add --virtual .drupal-phpexts-rundeps $runDeps \
      # Cleanup
      && rm -rf /tmp/pear ~/.pearrc \
      && chown -R www-data:www-data /usr/local/var/log \
      && docker-php-source delete \
      && apk del .build-deps .build-php-exts \
      && rm -rf /tmp/* /var/cache/apk/*
    
    #------------------------------------------------------------------------------
    # WEB DEV
    #------------------------------------------------------------------------------
    FROM nginx:1.17.4-alpine as web-prod
    
    WORKDIR /var/www/webroot
    
    CMD ["nginx", "-g", "daemon off;"]
    
