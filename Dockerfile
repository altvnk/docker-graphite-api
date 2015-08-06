FROM centos:centos6
MAINTAINER Mike Brannigan <mikejbrannigan@gmail.com>

RUN rpm -Uvh --quiet --force http://mirrors.kernel.org/fedora-epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN yum install -y --quiet wget git tar mod_wsgi cairo python-pip gcc cairo-devel python-devel libffi-devel

# Install graphite-api and cyanite
RUN pip install --quiet graphite-api
RUN pip install --quiet graphite-api[sentry,cyanite]

VOLUME [ "/var/log" ]
VOLUME [ "/var/www/html" ]

COPY files/etc/graphite-api.yaml /etc/graphite-api.yaml

COPY files/etc/httpd/conf.d/graphite.conf /etc/httpd/conf.d/graphite.conf

# Graphite wsgi script
COPY files/var/www/wsgi-scripts/graphite-api.wsgi /var/www/wsgi-scripts/graphite-api.wsgi

# Create graphite directory
RUN mkdir -p /srv/graphite
RUN chown apache:apache /srv/graphite

# Expose ports
EXPOSE 8000

# Run apache
ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]

