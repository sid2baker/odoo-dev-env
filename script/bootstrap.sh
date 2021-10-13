#!/bin/bash
set +e

VERSION=15.0

create_pod () {
  podman pod create -p 8069:8069 --name odoo-dev
  podman run --pod odoo-dev -d \
    -e POSTGRES_DB=postgres \
    -e POSTGRES_USER=odoo \
    -e POSTGRES_PASSWORD=odoo \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -v odoo-db-data:/var/lib/postgresql/data/pgdata \
    --name db postgres:13
  podman run --pod odoo-dev -dit \
    -v odoo-web-data:/var/lib/odoo \
    -v ./config:/etc/odoo:Z \
    -v ./src/enterprise:/home/odoo/enterprise:Z \
    -v ./addons:/home/odoo/user:Z \
    --entrypoint=/bin/bash \
    --name odoo odoo:$VERSION
}

if [ "$(podman pod ps | grep odoo-dev | wc -l)" == "0" ] ; then
  echo "> > > Starting PostgreSQL and Odoo"
  create_pod
else
  echo "Development pod is already running. Re-create it? Y/N"
  read input
  if [ $input == "Y" ] ; then
    podman pod stop odoo-dev
    podman pod rm odoo-dev
    podman volume rm odoo-db-data
    podman volume rm odoo-web-data
    create_pod
  else
    echo "Leaving bootstrap process."
    exit 0
  fi
fi
#./script/setup.sh
echo "> > > Attempting to start the app"
#./script/run.sh
