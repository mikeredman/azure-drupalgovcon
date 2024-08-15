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