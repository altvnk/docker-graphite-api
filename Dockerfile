FROM centos:latest
MAINTAINER Alexander Litvinenko <altvnk@me.com>

RUN yum install -y --quiet epel-release

RUN yum install -y --quiet wget git tar mod_wsgi cairo python-pip gcc cairo-devel python-devel libffi-devel

RUN pip install --quiet graphite-api[sentry,cyanite] importlib logutils --upgrade

COPY files/etc/graphite-api.yaml /etc/graphite-api.yaml

COPY files/etc/httpd/conf.d/graphite.conf /etc/httpd/conf.d/graphite.conf

COPY files/var/www/wsgi-scripts/graphite-api.wsgi /var/www/wsgi-scripts/graphite-api.wsgi

RUN mkdir -p /srv/graphite && chown apache:apache /srv/graphite

EXPOSE 8000

ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]

