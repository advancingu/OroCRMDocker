Docker container for OroCRM
===========================

This repository provides code to build a stateless Docker image of OroCRM Community Edition 1.8.2 for environments without interactive Docker shell access.

Pre-built images
----------------

A pre-built image is available under the tag `advancingu/orocrm` on DockerHub.

Building
--------

To build the Docker image, run

```bash
./oro/build-oro.sh
docker build -t orocrm .
```

Running OroCRM
--------------

Container environment variables are used to adapt application behavior to the runtime environment.

Running OroCRM with `docker-compose` will also launch an instance of MySQL. If you already have a MySQL database you want to use, simply comment out the `db` container in `docker-compose.yml` and set the following environment variables to match your situation:

```
DB_1_PORT_3306_TCP_ADDR
DB_1_PORT_3306_TCP_PORT
DB_1_ENV_MYSQL_DATABASE
DB_1_ENV_MYSQL_USER
DB_1_ENV_MYSQL_PASSWORD
```

If you want to run the OroCRM image stand-alone, you will need to assure these environment variables are set at container runtime.

A volume mount point `/var/www/app/app/attachment` is defined so that attachment files can be stored outside of containers.

Initial OroCRM setup
--------------------

To have OroCRM perform an initial database setup and installation, set an environment variable `INSTALL` to any value when you run the container.

The initial administrator user that will be created has username `initial` and password `123456`.

WARNING: In installation mode, OroCRM will drop any existing database (as defined in `DB_1_ENV_MYSQL_DATABASE`) without further confirmation.
