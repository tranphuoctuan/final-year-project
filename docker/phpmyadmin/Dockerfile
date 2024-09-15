FROM phpmyadmin/phpmyadmin:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the ServerName directive in Apache configuration
RUN echo "${DATABASE_HOST}" >> /etc/apache2/apache2.conf

# Ensure the document root directory exists
RUN mkdir -p /var/www/html

# Copy phpMyAdmin files to the Apache document root
COPY --from=phpmyadmin/phpmyadmin /etc/phpmyadmin /var/www/html

RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 81

# Start Apache in the foreground
CMD ["apache2-foreground"]
