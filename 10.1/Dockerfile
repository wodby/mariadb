FROM alpine:3.5

ENV GOTPL_VER 0.1.5
ENV MARIADB_VER 10.1.22-r0

RUN apk add --no-cache \
        bash \
        ca-certificates \
        make \
        mariadb=${MARIADB_VER} \
        mariadb-client \
        pwgen \
        tzdata \
        wget && \

    wget -qO- https://github.com/wodby/gotpl/releases/download/${GOTPL_VER}/gotpl-alpine-linux-amd64-${GOTPL_VER}.tar.gz | tar xz -C /usr/local/bin

RUN mkdir -p /var/run/mysqld && mkdir -p /var/lib/mysql
RUN chown -R mysql:mysql /var/run/mysqld && chown -R mysql:mysql /var/lib/mysql

RUN mkdir /docker-entrypoint-initdb.d
COPY actions /usr/local/bin

RUN chown mysql:mysql /usr/local/bin/actions.mk /usr/local/bin/wait-for-mariadb.sh

COPY *.tpl /etc/gotpl/
COPY docker-entrypoint.sh /

WORKDIR /var/lib/mysql
VOLUME /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld"]
