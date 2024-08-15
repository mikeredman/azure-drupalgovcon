
#------------------------------------------------------------------------------
# Composer PROD
#------------------------------------------------------------------------------
    FROM composer:2.4.4 as composer-prod

    # Make the directories for the composer cache and the project.
    RUN mkdir -p /var/www/webroot/core \
          /var/www/webroot/libraries \
          /var/www/webroot/modules/contrib \
          /var/www/webroot/profiles/contrib \
          /var/www/webroot/themes/contrib \
          /var/www/webroot/sites/all/drush/contrib \
          /var/www/vendor
    
    
    COPY composer.json composer.lock /var/www/
    COPY scripts /var/www/scripts
    COPY php /var/www/php
    COPY private-files /var/www/private-files
    RUN chown -R www-data:www-data /var/www/php
    RUN chown -R www-data:www-data /var/www/private-files
    COPY patches /var/www/patches
    
    WORKDIR /var/www
    
    # The following flag breaks drupal --classmap-authoritative
    RUN  composer install \
           --ignore-platform-reqs \
           #--optimize-autoloader \
           --no-interaction \
           --no-progress 
           #--prefer-dist \
           #--no-scripts \
           #--no-ansi \
           #--no-dev
    


#------------------------------------------------------------------------------
# PHP PROD
#------------------------------------------------------------------------------
FROM drupal:8.7.8-fpm-alpine as php-prod

# Set timezone.
ENV PHP_TIMEZONE America/New_York
RUN echo "date.timezone = \"$PHP_TIMEZONE\"" > /usr/local/etc/php/conf.d/timezone.ini

WORKDIR /var/www/webroot


#------------------------------------------------------------------------------
# WEB PROD
#------------------------------------------------------------------------------
FROM nginx:1.17.4-alpine as web-prod

ENV NGINX_VERSION nginx-1.17.4
    
#COPY --from=php-prod /var/www/webroot /var/www/webroot

    