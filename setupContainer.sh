#!/bin/bash

BASEDIR=$(readlink -f $(dirname $0))
SCRIPT_DIR=./img-scripts

set -e

# Add common variables.
echo ">>>> Import common variables."
source ${BASEDIR}/config
source ${BASEDIR}/config.default

#Create administrator in Gerrit.
echo ">>>> Setup Gerrit."
source ${SCRIPT_DIR}/gerrit-docker/addGerritUser.sh

#Integrate Jenkins with Gerrit.
echo ">>>> Setup Jenkins."
source ${SCRIPT_DIR}/jenkins-docker/setupJenkins.sh

#Integrate Redmine with Openldap and import init data.
echo ">>>> Setup Redmine."
source ${SCRIPT_DIR}/redmine-docker/setupRedmine.sh

#Restart Nginx proxy.
echo ">>>> Restart Nginx proxy."
docker restart ${NGINX_NAME}

