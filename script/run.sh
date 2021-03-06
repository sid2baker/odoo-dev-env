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
  restart   Restart Odoo
  *         Help
"
  exit 1
}

case "$1" in
  attach|a)
    podman attach odoo
    ;;
  shell|c)
    podman exec -it --user=root odoo /bin/bash
    ;;
  start|s)
    podman pod start odoo-dev
    podman attach odoo
    ;;
  stop|x)
    podman pod stop odoo-dev
    ;;
  restart|r)
    podman stop odoo
    podman start odoo
    ;;
  *)
    cli_help
    ;;
esac
