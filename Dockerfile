FROM clouder/clouder-base
MAINTAINER Yannick Buron yburon@goclouder.net

# Install required system packages
RUN apt-get update && apt-get install -yq libxml2-dev apache2 php5 php5-mhash php5-mcrypt php5-curl php5-cli php5-mysql php5-gd php5-intl php5-xsl
# Update user www-data to use magento
RUN usermod -u 1000 www-data
# Create directory structure for volumes
RUN mkdir -p /opt/magento/exec/var/log
RUN mkdir -p /opt/magento/exec/app/etc
RUN mkdir -p /opt/magento/exec/app/code/local
RUN chown -R www-data:www-data /opt/magento/
# Make a symlink for magento files
RUN ln -s /opt/magento/exec /var/www/htdocs
RUN chown -h www-data:www-data /var/www/htdocs
# Add dummy magento config file for the a2ensite command
RUN touch /etc/apache2/sites-available/magento.conf
# Finish configuring Apache/PHP
RUN php5enmod mcrypt
RUN a2enmod rewrite
RUN a2ensite magento.conf
RUN a2dissite 000-default.conf
# Stop apache to trigger restart when the command running the container is launched
RUN /etc/init.d/apache2 stop
# Removing dummy config file now the site is enabled
RUN rm -f /etc/apache2/sites-available/magento.conf
# Launch apache in foreground
CMD apache2ctl -DFOREGROUND
