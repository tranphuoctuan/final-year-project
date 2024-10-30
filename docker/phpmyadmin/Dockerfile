FROM phpmyadmin/phpmyadmin:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "${DATABASE_HOST}" >> /etc/apache2/apache2.conf
RUN mkdir -p /var/www/html

COPY --from=phpmyadmin/phpmyadmin /etc/phpmyadmin /var/www/html

RUN chown -R www-data:www-data /var/www/html

EXPOSE 81

CMD ["apache2-foreground"]
