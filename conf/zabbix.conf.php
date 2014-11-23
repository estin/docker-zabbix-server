<?php
global $DB;

$DB['TYPE']     = 'POSTGRESQL';
$DB['DATABASE'] = '{{ ZABBIX_DB_NAME }}';
$DB['USER']     = '{{ ZABBIX_DB_USER }}';
$DB['PASSWORD'] = '{{ ZABBIX_DB_PASS }}';
$DB['SERVER']   = '{{ ZABBIX_DB_HOST }}';
$DB['PORT']     = '{{ ZABBIX_DB_PORT }}';

// SCHEMA is relevant only for IBM_DB2 database
$DB['SCHEMA'] = '';

$ZBX_SERVER      = 'localhost';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = '{{ ZABBIX_INSTALLATION_NAME }}';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
