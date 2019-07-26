FROM debian:jessie

RUN \
  apt-get update && \
  apt-get -y install apache2 tcl && \
  a2enmod cgi rewrite

RUN ln -sf /dev/stderr /var/log/apache2/error.log
RUN ln -sf /dev/stdout /var/log/apache2/access.log

COPY default.conf /etc/apache2/sites-available/000-default.conf
COPY ./www/ /var/www/

ARG COMMIT
ENV COMMIT=$COMMIT
ARG LASTMOD
ENV LASTMOD=$LASTMOD

ENV PORT=8080

EXPOSE 80
CMD sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf && /usr/sbin/apache2ctl -D FOREGROUND


