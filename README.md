Zabbix Server & Web UI
======================

Contains:

* Zabbix Server
* Zabbinx Front-end
* Nginx
* PHP

Processes are managed by supervisord, including cronjobs


Exports
-------

* Nginx on `80`
* Zabbix Server on `10051`
* `/etc/zabbix/alert.d/` for Zabbix alertscripts

Variables
---------

* `ZABBIX_DB_NAME=zabbix`: PostgreSQL database to work on
* `ZABBIX_DB_USER=zabbix`: PostgreSQL user/role
* `ZABBIX_DB_PASS=zabbix`: The user password
* `ZABBIX_DB_HOST=localhost`: PostgreSQL host to connect to
* `ZABBIX_DB_PORT=5432`: PostgreSQL port

* `ZABBIX_INSTALLATION_NAME=`: Zabbix installation name

Linking:

* `ZABBIX_DB_LINK=`: Database link name. Example: a value of "DB_PORT_5432" will fill in `ZABBIX_DB_HOST/PORT` variables

Constants in Dockerfile
-----------------------

* `ZABBIX_PHP_TIMEZONE=UTC`: Timezone to use with PHP

Example
-------

Launch PostgreSQL database container with name 'zabbix-db'. Create the necessary user and database:

    $ docker run -d --name="zabbix-db" postgres
    $ docker exec -it zabbix-db /bin/bash
    ...$ psql -U postgres
    postgres=# create user zabbix password 'zabbix';
    postgres=# create database zabbix owner zabbix;
    postgres=# Ctrl-D
    ...$ Ctrl-D

Launch Zabbix container:

    $ docker run -d --name="zabbix" --link zabbix-db:db -e ZABBIX_DB_LINK=DB_PORT_5432 -p 80:80 -p 10051:10051 estin/zabbix-server

By default, you sign in as Admin:zabbix.

Enjoy! :)

Configuration Cheat-Sheet
-------------------------

Things to do at the beginning:

* Administration > Users, Users: disable guest access (group), setup user accounts & themes
* Administration > Media types: set up notification methods. For custom alertscripts, see [Custom alertscripts](https://www.zabbix.com/documentation/2.4/manual/config/notifications/media/script)
* Administration > Users, Users, "Media" tab: set up notification destinations
