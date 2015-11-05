#!/bin/bash

set -ev

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
BUILD_DIR=$SCRIPT_DIR/build

# Clean up old build files
if [ -d ${BUILD_DIR} ]; then
    echo "Removing ${BUILD_DIR}."
    rm -rf ${BUILD_DIR}
fi

mkdir -p $BUILD_DIR/bin

curl -sS https://getcomposer.org/installer | php -- --install-dir=$BUILD_DIR/bin --filename=composer

cd $BUILD_DIR

git clone "https://github.com/orocrm/crm-application.git" code

ORO_CODE_DIR=$BUILD_DIR/code
cd $ORO_CODE_DIR

git checkout tags/1.8.2

$BUILD_DIR/bin/composer --working-dir=$ORO_CODE_DIR --no-dev --prefer-dist --no-interaction install

sed -i -r 's/ \- \{ resource: parameters\.yml \}/ - { resource: parameters.yml }\n    - { resource: parameters.php }/' $ORO_CODE_DIR/app/config/config.yml

cp $SCRIPT_DIR/parameters.php $ORO_CODE_DIR/app/config/
sed -i 's/database_host\: 127\.0\.0\.1/database_host: db/' $ORO_CODE_DIR/app/config/parameters.yml
sed -i "s/installed: null/installed: '2015-10-01T00:00:00+00:00'/" $ORO_CODE_DIR/app/config/parameters.yml

# Allow accessing app_dev.php
#sed -i 's/header/\/\/header/' $ORO_CODE_DIR/web/app_dev.php
#sed -i 's/exit/\/\/exit/' $ORO_CODE_DIR/web/app_dev.php

# See https://github.com/orocrm/platform/issues/331
sed -i 's/255/242/' $ORO_CODE_DIR/app/OroRequirements.php

tar -czf ../code.tar.gz *
