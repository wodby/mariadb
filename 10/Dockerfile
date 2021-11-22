ARG BASE_IMAGE_TAG

FROM wodby/alpine:${BASE_IMAGE_TAG}

ARG MARIADB_VER
ARG GALERA_VER
ARG WSREP_VER
ARG NPROC

ENV MARIADB_VER="${MARIADB_VER}" \
    GALERA_VER="${GALERA_VER}" \
    BACKUPS_DIR="/mnt/backups"

COPY patches /tmp/patches

RUN set -xe; \
    \
    addgroup -g 101 -S mysql; \
    adduser -u 100 -D -S -s /bin/bash -G mysql mysql; \
    echo "PS1='\w\$ '" >> /home/mysql/.bashrc; \
    \
    apk add --update --no-cache -t .mariadb-run-deps \
        libaio \
        libstdc++ \
        libxml2 \
        linux-pam \
        make \
        $(test "${MARIADB_VER:3:1}" -ge 5 && echo 'pcre2' || echo 'pcre') \
        pwgen \
        sudo \
        tzdata \
        xz-libs \
        zlib; \
    \
    apk add --update --no-cache -t .mariadb-build-deps \
        attr \
        autoconf \
        bison \
        build-base \
        cmake \
        coreutils \
        gnupg \
        libaio-dev \
        linux-pam-dev \
        openssl-dev \
        linux-headers \
        ncurses-dev \
        patch \
        $(test "${MARIADB_VER:3:1}" -ge 5 && echo 'pcre2-dev' || echo 'pcre-dev') \
        readline-dev \
        xz-dev \
        zlib-dev; \
    \
    mariadb_url="https://downloads.mariadb.com/MariaDB/mariadb-${MARIADB_VER}/source/mariadb-${MARIADB_VER}.tar.gz"; \
    curl -fSL "${mariadb_url}" -o /tmp/mariadb.tar.gz; \
    curl -fSL "${mariadb_url}.asc" -o /tmp/mariadb.tar.gz.asc; \
    GPG_KEYS="199369E5404BD5FC7D2FE43BCBCB082A1BB943DB;430BDF5C56E7C94E848EE60C1C4CBDCDCD2EFD2A;4D1BB29D63D98E422B2113B19334A25F8507EFA5" gpg_verify /tmp/mariadb.tar.gz.asc /tmp/mariadb.tar.gz; \
    \
    tar zxf /tmp/mariadb.tar.gz -C /tmp; \
    #
    # Optional Galera Build/Install
    #
    if [ -n "${GALERA_VER}" ]; then \
        apk add --update --no-cache -t .galera-run-deps \
            boost-program_options \
            rsync \
            socat; \
        apk add --update --no-cache -t .galera-build-deps \
            boost-dev \
            check-dev \
            scons; \
        galera_url="https://github.com/codership/galera/archive/release_${GALERA_VER}.tar.gz"; \
        curl -fSL "${galera_url}" -o /tmp/galera.tar.gz; \
        tar zxf /tmp/galera.tar.gz -C /tmp; \
        rmdir "/tmp/galera-release_${GALERA_VER}/wsrep/src"; \
        ln -s "/tmp/mariadb-${MARIADB_VER}/wsrep-lib/wsrep-API/v${WSREP_VER}" "/tmp/galera-release_${GALERA_VER}/wsrep/src"; \
        \
        cd "/tmp/galera-release_${GALERA_VER}"; \
        for i in /tmp/patches/galera/"${GALERA_VER:0:4}"/*.patch; do patch -p1 -i "${i}"; done; \
        RUN_TESTS=0 scripts/build.sh -j "${NPROC:-$(nproc)}"; \
        apk del --purge .galera-build-deps; \
        \
        mkdir -p /usr/lib/galera; \
        cp -a "/tmp/galera-release_${GALERA_VER}/libgalera_smm.so" /usr/lib/galera; \
        chown -R mysql:mysql /usr/lib/galera; \
        \
        cp -a "/tmp/galera-release_${GALERA_VER}/garb/garbd" /usr/sbin; \
    fi; \
    \
    #
    # MariaDB Build
    #
    cd "/tmp/mariadb-${MARIADB_VER}"; \
    # From alpine repository https://git.alpinelinux.org/cgit/aports/tree/main/mariadb?h=3.6-stable
    for i in /tmp/patches/"${MARIADB_VER:0:4}"/*.patch; do patch -p1 -i "${i}"; done; \
    \
    cmake . -DBUILD_CONFIG=mysql_release \
    		-DCMAKE_BUILD_TYPE=MinSizeRel \
    		-DCMAKE_INSTALL_PREFIX=/usr \
    		-DSYSCONFDIR=/etc/mysql \
    		-DMYSQL_DATADIR=/var/lib/mysql \
    		-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock \
		    -DDEFAULT_CHARSET=utf8mb4 \
		    -DDEFAULT_COLLATION=utf8mb4_general_ci \
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
    		-DCONNECT_WITH_MYSQL=ON \
            -DCONNECT_WITH_LIBXML2=system \
            -DCONNECT_WITH_ODBC=NO \
            -DCONNECT_WITH_JDBC=NO \
    		-DPLUGIN_ARCHIVE=YES \
            -DPLUGIN_ARIA=YES \
            -DPLUGIN_BLACKHOLE=YES \
            -DPLUGIN_CASSANDRA=NO \
            -DPLUGIN_CSV=YES \
            -DPLUGIN_MYISAM=YES \
            -DPLUGIN_MROONGA=NO \
            -DPLUGIN_OQGRAPH=NO \
            -DPLUGIN_PARTITION=YES \
            -DPLUGIN_ROCKSDB=NO \
            -DPLUGIN_SPHINX=NO \
            -DPLUGIN_TOKUDB=NO \
            -DPLUGIN_AUTH_GSSAPI=NO \
            -DPLUGIN_AUTH_GSSAPI_CLIENT=OFF \
            -DPLUGIN_CRACKLIB_PASSWORD_CHECK=NO \
    		-DWITH_ASAN=OFF \
            -DWITH_EMBEDDED_SERVER=ON \
            -DWITH_EXTRA_CHARSETS=complex \
            -DWITH_INNODB_BZIP2=OFF \
            -DWITH_INNODB_LZ4=OFF \
            -DWITH_INNODB_LZMA=ON \
            -DWITH_INNODB_LZO=OFF \
            -DWITH_INNODB_SNAPPY=OFF \
            -DWITH_JEMALLOC=NO \
            -DWITH_LIBARCHIVE=system \
            -DWITH_LIBNUMA=NO \
            -DWITH_LIBWRAP=OFF \
            -DWITH_LIBWSEP=OFF \
            -DWITH_MARIABACKUP=ON \
            -DWITH_PCRE=system \
            -DWITH_READLINE=ON \
            -DWITH_SYSTEMD=no \
            -DWITH_SSL=system \
            -DWITH_VALGRIND=OFF \
            -DWITH_ZLIB=system; \
    \
    make -j "${NPROC:-$(nproc)}"; \
    make install; \
    \
    # Script to fix volumes permissions via sudo.
    echo "chown mysql:mysql /var/lib/mysql ${BACKUPS_DIR}" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes; \
    echo 'mysql ALL=(root) NOPASSWD: /usr/local/bin/init_volumes' > /etc/sudoers.d/mysql; \
    \
    mkdir -p \
        /var/run/mysqld \
        /var/lib/mysql \
        /etc/mysql/certificates \
        /docker-entrypoint-initdb.d \
        "${BACKUPS_DIR}"; \
    \
    chown -R mysql:mysql \
        /var/run/mysqld \
        /var/lib/mysql \
        /usr/lib/mysql/plugin \
        /etc/mysql \
        /docker-entrypoint-initdb.d \
        "${BACKUPS_DIR}"; \
    \
    # Remove dev, test, doc, benchmark related files.
    rm -rf \
        /usr/bin/mysql_client_test \
        /usr/bin/mysql_client_test_embedded \
        /usr/bin/mysql_config \
        /usr/bin/mysqltest \
        /usr/bin/mysqltest_embedded \
        /usr/include/mysql \
        /usr/lib/libmariadb.so* \
        /usr/lib/libmariadbd.so.* \
        /usr/lib/libmysqlclient.so* \
        /usr/lib/libmysqlclient_r.so* \
        /usr/lib/libmysqld.so.* \
        /usr/mysql-test \
        /usr/share/man \
        /usr/sql-bench; \
    \
    find /usr/lib -name '*.a' -maxdepth 1 -print0 | xargs -0 rm; \
    find /usr/lib -name '*.so' -type l -maxdepth 1 -print0 | xargs -0 rm; \
    \
    # Stripping binaries and .so files.
    scanelf --symlink --recursive --nobanner --osabi --etype "ET_DYN,ET_EXEC" \
        /usr/bin/* /usr/sbin/* /usr/lib/mysql/plugin/* /usr/lib/galera/* | while read type osabi filename; do \
        ([ "$osabi" != "STANDALONE" ] && [ "${filename}" != "/usr/bin/strip" ]) || continue; \
        XATTR=$(getfattr --match="" --dump "${filename}"); \
        strip "${filename}"; \
        if [ -n "$XATTR" ]; then \
            echo "$XATTR" | setfattr --restore=-; \
        fi; \
    done; \
    \
    # Clean up.
    apk del --purge .mariadb-build-deps; \
    rm -rf /tmp/*; \
    rm -rf /var/cache/apk/*

USER mysql

COPY bin /usr/local/bin
COPY templates /etc/gotpl/
COPY docker-entrypoint.sh /

WORKDIR /var/lib/mysql
VOLUME /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld"]
