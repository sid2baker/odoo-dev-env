#!/bin/bash
set +e

create_pod () {
  podman pod create -p 8080:8069 --name odoo-dev
  podman run --pod odoo-dev -d \
    -e POSTGRES_DB=postgres \
    -e POSTGRES_USER=odoo \
    -e POSTGRES_PASSWORD=odoo \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -v odoo-db-data:/var/lib/postgresql/data/pgdata \
    --name db postgres:10
  podman run --pod odoo-dev -d \
    -v odoo-web-data:/var/lib/odoo \
    -v ./config:/etc/odoo:Z \
    -v ./enterprise:/home/odoo/enterprise:Z \
    -v ./addons:/home/odoo/user:Z \
    --name odoo odoo:latest
}

if [ "$(podman pod ps | grep odoo-dev | wc -l)" == "0" ] ; then
  echo "> > > Starting PostgreSQL and Odoo"
  create_pod
else
  echo "Development pod is already running. Re-create it? Y/N"
  read input
  if [ $input == "Y" ] ; then
    podman pod rm odoo-dev -f
    create_pod
  else
    echo "Leaving bootstrap process."
    exit 0
  fi
fi
#./script/setup.sh
echo "> > > Attempting to start the app"
#./script/run.sh
