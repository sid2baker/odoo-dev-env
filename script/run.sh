#!/bin/bash
set -e

cli_help() {
  cli_name=${0##*/}
  echo "
$cli_name
Odoo Run CLI
Version: $(cat ./VERSION)
Usage: $cli_name [command]
Commands:
  attach    Attach to odoo instance
  start     Starting the pod
  stop      Stopping the pod
  *         Help
"
  exit 1
}

case "$1" in
  attach|a)
    podman attach odoo
    ;;
  shell|c)
    podman exec -it odoo /bin/bash
    ;;
  start|s)
    podman pod start odoo-dev
    podman attach odoo
    ;;
  stop|x)
    podman pod stop odoo-dev
    ;;
  *)
    cli_help
    ;;
esac
