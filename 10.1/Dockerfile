FROM alpine:3.5

ENV GOTLP_VER 0.1.5
ENV MARIADB_VER 10.1.21-r0

RUN set -e && \
	addgroup -S mysql && \
	adduser -D -S -s /bin/bash -G mysql mysql

RUN apk add --no-cache \
        bash \
        ca-certificates \
        make \
        mariadb=${MARIADB_VER} \
        mariadb-client \
        pwgen \
        tzdata \
        wget && \

    # Download and install Gotlp
    wget -qO- https://github.com/wodby/gotpl/releases/download/${GOTLP_VER}/gotpl-alpine-linux-amd64-${GOTLP_VER}.tar.gz | tar xz -C /usr/local/bin

RUN mkdir -p /var/run/mysqld
RUN chown -R mysql:mysql /var/run/mysqld

RUN mkdir /docker-entrypoint-initdb.d
COPY scripts /usr/local/bin

RUN chown mysql:mysql /usr/local/bin/actions.mk /usr/local/bin/wait-for-mariadb.sh

COPY *.tpl /etc/gotpl/

WORKDIR /var/lib/mysql
VOLUME /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld"]
