FROM alpine:3.5

ENV GOTLP_VER 0.1.5
ENV MARIADB_VER 10.1.21-r0

RUN apk add --no-cache \
        bash \
        ca-certificates \
        tar \
        tzdata \
        wget \
        pwgen \
        mariadb=${MARIADB_VER} \
        mariadb-client && \

    # Download and install Gotlp
    wget -qO- https://github.com/wodby/gotpl/releases/download/${GOTLP_VER}/gotpl-alpine-linux-amd64-${GOTLP_VER}.tar.gz | tar xz -C /usr/local/bin

RUN mkdir -p /var/run/mysqld
RUN chown 100:101 /var/run/mysqld

RUN mkdir /docker-entrypoint-initdb.d
COPY docker-entrypoint.sh /

COPY *.tpl /etc/gotpl/

WORKDIR /var/lib/mysql
VOLUME /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld"]
