#!/bin/bash

set -ev

cd /var/www/app

if [ "$INSTALL" ]; then
	app/console oro:install --force --env prod --no-interaction --user-name=initial --user-email=a@b.com --user-firstname=John --user-lastname=Doe --user-password=123456 --timeout 600
else
	# See https://github.com/orocrm/platform/blob/master/src/Oro/Bundle/InstallerBundle/Command/InstallCommand.php
	app/console oro:navigation:init --process-isolation
	app/console fos:js-routing:dump --target web/js/routes.js --process-isolation
	app/console oro:localization:dump
	app/console oro:assets:install --exclude OroInstallerBundle
	app/console assetic:dump --process-isolation
	app/console oro:translation:dump --process-isolation
	app/console oro:requirejs:build --process-isolation
	app/console cache:clear --env prod --process-isolation
fi

chown -R www-data:www-data /var/www/app/app/cache /var/www/app/app/logs /var/www/app/web /var/www/app/app/attachment /var/www/app/app/config/parameters.yml

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
