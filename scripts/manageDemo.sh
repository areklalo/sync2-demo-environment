#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )";

function main () {
  local should_clear=0;
  local should_reset=0;
  local should_stop=0;
  local should_start=0;
  local should_log=0;
  local should_build=0;

  while getopts ':hsulrvb' option; do
    case "$option" in
      h) usage
         exit
         ;;
      s) should_stop=1
         ;;
      u) should_start=1
         ;;
      l) should_log=1
         ;;
      r) should_reset=1
         ;;
      v) should_clear=1
         ;;
      b) should_build=1
         ;;
      :) printf "missing argument for -%s\n" "$OPTARG" >&2
         usage
         exit 1
         ;;
     \?) printf "illegal option: -%s\n" "$OPTARG" >&2
         usage
         exit 1
         ;;
    esac
  done
  shift $((OPTIND - 1))

  if [ $should_reset -ne 0 ]; then
    resetDocker $should_clear $should_build
  else
    if [ $should_stop -ne 0 ]; then
      stopDocker $should_clear
    fi
    if [ $should_start -ne 0 ]; then
      startDocker $should_build
    fi
  fi

  if [ $should_log -ne 0 ]; then
    logDocker
  fi
}

function usage() { echo "$(basename "$0") [-h|s|u|l|r|v|b]
-- script used to manage the docker of Sync 2 demo environment

where:
    -h  show this help text
    -s  stop the demo-environment
    -u  start the demo-environment
    -l  show logs
    -r  reset the demo-environment
    -v  clear the demo-environment (works with [-s|r])
    -b  rebuild the docker images (works with [-u|r])"
    >&2
}

function stopDocker() {
  if [ $1 -ne 0 ]; then
    clearDocker
  else
    (cd $SCRIPT_DIR/..; docker-compose stop);
  fi
}

function startDocker() {
  if [ $1 -ne 0 ]; then
    (cd $SCRIPT_DIR/..; docker-compose up -d --build);
  else
    (cd $SCRIPT_DIR/..; docker-compose up -d);
  fi
}

function logDocker() {
  (cd $SCRIPT_DIR/..; docker-compose logs -f);
}

function resetDocker() {
  stopDocker $1
  startDocker $2
}

function clearDocker() {
  (cd $SCRIPT_DIR/..; docker-compose down -v);
}

main "$@"
