<?php
/*
 * Override parameters when corresponding env-vars are set (e.g. in a docker-container)
 */

$parameters = [
    'DB_1_PORT_3306_TCP_ADDR' => 'database_host',
    'DB_1_PORT_3306_TCP_PORT' => 'database_port',
    'DB_1_ENV_MYSQL_DATABASE' => 'database_name',
    'DB_1_ENV_MYSQL_USER' => 'database_user',
    'DB_1_ENV_MYSQL_PASSWORD' => 'database_password',
];

foreach ($parameters as $envVar => $sfParam) {
    $value = getenv($envVar);
    if ($value !== false && $value !== '') {
        $container->setParameter($sfParam, $value);
    }
}
