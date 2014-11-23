#! /usr/bin/env bash
set -eu # exit on error or undefined variable

# Variables
export ZABBIX_PHP_TIMEZONE=${ZABBIX_PHP_TIMEZONE:-"UTC"}
export ZABBIX_DB_NAME=${ZABBIX_DB_NAME:-"zabbix"}
export ZABBIX_DB_USER=${ZABBIX_DB_USER:-"zabbix"}
export ZABBIX_DB_PASS=${ZABBIX_DB_PASS:-"zabbix"}
export ZABBIX_DB_HOST=${ZABBIX_DB_HOST:-"localhost"}
export ZABBIX_DB_PORT=${ZABBIX_DB_PORT:-"5432"}
export ZABBIX_INSTALLATION_NAME=${ZABBIX_INSTALLATION_NAME:-""}
if [ ! -z "$ZABBIX_DB_LINK" ] ; then
    eval export ZABBIX_DB_HOST=\$${ZABBIX_DB_LINK}_TCP_ADDR
    eval export ZABBIX_DB_PORT=\$${ZABBIX_DB_LINK}_TCP_PORT
fi

# Templates
j2 /root/conf/zabbix.conf.php > /etc/zabbix/zabbix.conf.php
j2 /root/conf/zabbix_server.conf > /etc/zabbix/zabbix_server.conf

# Service commands
[ $# -eq 1 ] &&
    case "$1" in
        # Install tables into MySQL
        setup-db)
            apt-get install -qq -y --no-install-recommends postgresql-client
            zcat /usr/share/zabbix-server-pgsql/{schema,images,data}.sql.gz | PGPASSWORD=$ZABBIX_DB_PASS psql -h $ZABBIX_DB_HOST -U $ZABBIX_DB_USER $ZABBIX_DB_NAME
            apt-get purge -qq -y postgresql-client postgresql-client-common
            exit 0
            ;;
    esac

# Logging - uncomment if you want scrolling logs (and you should omit '-d' when running the container):
#LOGFILES=$(echo /var/log/{nginx/error,nginx/http.error,php5-fpm,supervisord,zabbix-server/zabbix_server}.log)
#( umask 0 && truncate -s0 $LOGFILES ) && tail --pid $$ -n0 -F $LOGFILES &

# Launch
rm -f /var/run/{nginx,php5-fpm,zabbix/zabbix_server}.pid
exec /usr/bin/supervisord -n
