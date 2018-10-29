#!/bin/bash
function main () {
  local module_path='';
  local should_build=0;

  while getopts ':hp:b' option; do
    case "$option" in
      h) usage
         exit
         ;;
      b) should_build=1
         ;;
      p) module_path=$OPTARG
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

  if [ -z $module_path ]; then
    echo "missing the module path argument"
    usage
    exit 1
  fi

  if [ $should_build -ne 0 ]; then
    buildModule $module_path
  fi

  reloadModule $module_path
}

function usage() { echo "$(basename "$0") [-h] [-b] [-p path_to_module]
-- script used to reload module in the Sync 2 demo environment

where:
    -h  show this help text
    -b  build the module before reload
    -p  path to module [mandatory]"  >&2
}

function buildModule() {
  echo "BUILDING THE $1 MODULE";
  mvn clean install -f $1
}

function reloadModule() {
  local scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )";
  local moduleDir=$1;
  local omodDir=$moduleDir'/omod/target';
  echo "RELOAD THE $moduleDir MODULE";
  if [ ! -d $omodDir ]; then
      echo "Directory $omodDir not found!";
      exit 1;
  fi

  local omodFile=`ls $omodDir/*.omod`;
  if [ ! -f $omodFile ]; then
      echo "Omod file not found!";
      exit 1;
  fi

  cp $omodFile $scriptDir/../modules
  sendFileToDockerContainers $omodFile

  $scriptDir/manageDemo.sh -r
}

function sendFileToDockerContainers() {
  local omodFile=$1;
  if [ `docker inspect -f '{{.State.Running}}' sync2_parent` == "true" ]; then
    docker cp $omodFile "sync2_parent:/usr/local/tomcat/.OpenMRS/modules/";
  fi
  if [ `docker inspect -f '{{.State.Running}}' sync2_child1` == "true" ]; then
    docker cp $omodFile "sync2_child1:/usr/local/tomcat/.OpenMRS/modules/";
  fi
  if [ `docker inspect -f '{{.State.Running}}' sync2_child2` == "true" ]; then
    docker cp $omodFile "sync2_child2:/usr/local/tomcat/.OpenMRS/modules/";
  fi
}

main "$@"
