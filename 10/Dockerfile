FROM wodby/alpine:3.6-1.0.0

ARG MARIADB_VER

ENV MARIADB_VER="${MARIADB_VER}" \
    MARIADB_URL="https://downloads.mariadb.org/interstitial/mariadb-${MARIADB_VER}/source/mariadb-${MARIADB_VER}.tar.gz"

COPY patches /tmp/patches

RUN set -xe && \

    addgroup -g 101 -S mysql && \
	adduser -u 100 -D -S -s /bin/bash -G mysql mysql && \
	echo "PS1='\w\$ '" >> /home/mysql/.bashrc && \

    apk add --update --no-cache --virtual .mariadb-run-deps \
        libaio \
        libstdc++ \
        make \
        pwgen \
        sudo \
        tzdata && \

    apk add --update --no-cache --virtual .mariadb-build-deps \
        autoconf \
        bison \
        build-base \
        cmake \
        coreutils \
        libaio-dev \
        libressl-dev \
        linux-headers \
        ncurses-dev \
        readline-dev \
        zlib-dev && \

    wget -qO- ${MARIADB_URL} | tar xz -C /tmp && \

    cd /tmp/mariadb-* && \

    # From alpine repository https://git.alpinelinux.org/cgit/aports/tree/main/mariadb?h=3.6-stable
    patch -p1 -i /tmp/patches/fix-mysql-install-db-path.patch && \
	patch -p1 -i /tmp/patches/fix-ucontext-check.patch && \
	patch -p1 -i /tmp/patches/ppc-remove-glibc-dep.patch && \

    cmake . -DBUILD_CONFIG=mysql_release \
    		-DCMAKE_INSTALL_PREFIX=/usr \
    		-DSYSCONFDIR=/etc/mysql \
    		-DMYSQL_DATADIR=/var/lib/mysql \
    		-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock \
    		-DDEFAULT_CHARSET=utf8 \
    		-DDEFAULT_COLLATION=utf8_general_ci \
    		-DENABLED_LOCAL_INFILE=ON \
    		-DINSTALL_INFODIR=share/mysql/docs \
    		-DINSTALL_MANDIR=share/man \
    		-DINSTALL_PLUGINDIR=lib/mysql/plugin \
    		-DINSTALL_SCRIPTDIR=bin \
    		-DINSTALL_INCLUDEDIR=include/mysql \
    		-DINSTALL_DOCREADMEDIR=share/mysql \
    		-DINSTALL_SUPPORTFILESDIR=share/mysql \
    		-DINSTALL_MYSQLSHAREDIR=share/mysql \
    		-DINSTALL_DOCDIR=share/mysql/docs \
    		-DINSTALL_SHAREDIR=share/mysql \
    		-DWITH_READLINE=ON \
    		-DWITH_ZLIB=system \
    		-DWITH_SSL=system \
    		-DWITH_LIBWRAP=OFF \
    		-DWITH_JEMALLOC=no \
    		-DWITH_EXTRA_CHARSETS=complex \
    		-DWITH_EMBEDDED_SERVER=ON \
    		-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
    		-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    		-DWITH_INNOBASE_STORAGE_ENGINE=1 \
    		-DWITH_PARTITION_STORAGE_ENGINE=1 \
    		-DPLUGIN_TOKUDB=NO \
    		-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
    		-DWITHOUT_FEDERATED_STORAGE_ENGINE=1 \
    		-DWITHOUT_PBXT_STORAGE_ENGINE=1 && \

    make && \
    make install && \

    echo 'mysql ALL=(root) NOPASSWD: /usr/local/bin/fix-permissions.sh' > /etc/sudoers.d/mysql && \
    mkdir -p /var/run/mysqld /var/lib/mysql /etc/mysql /docker-entrypoint-initdb.d && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql /etc/mysql /docker-entrypoint-initdb.d && \

    # Clean up.
    apk del --purge .mariadb-build-deps && \
    rm -rf /tmp/*

USER mysql

COPY actions /usr/local/bin
COPY my.cnf.tpl /etc/gotpl/
COPY docker-entrypoint.sh /

WORKDIR /var/lib/mysql
VOLUME /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld"]
