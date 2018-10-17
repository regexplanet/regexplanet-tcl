FROM debian:jessie

RUN \
  apt-get update && \
  apt-get -y install apache2 tcl && \
  a2enmod cgi

RUN ln -sf /dev/stderr /var/log/apache2/error.log
RUN ln -sf /dev/stdout /var/log/apache2/access.log

COPY default.conf /etc/apache2/sites-available/000-default.conf
COPY ./www/ /var/www/

EXPOSE 80
CMD /usr/sbin/apache2ctl -D FOREGROUND


