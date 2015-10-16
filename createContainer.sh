#!/bin/bash
set -e

BASEDIR=$(readlink -f $(dirname $0))
SCRIPT_DIR=./img-scripts

# Add common variables.
source ${BASEDIR}/config
source ${BASEDIR}/config.default

# Create Nexus server.
if [ ${#NEXUS_WEBURL} -eq 0 ]; then
    source ${SCRIPT_DIR}/nexus-docker/createNexus.sh
fi

# Create OpenLDAP server.
if [ ${#SLAPD_DOMAIN} -gt 0 -a ${#SLAPD_PASSWORD} -gt 0 ]; then
    source ${SCRIPT_DIR}/openldap-docker/createOpenLDAP.sh
fi

# Create Gerrit server container.
source ${SCRIPT_DIR}/gerrit-docker/createGerrit.sh

# Create Jenkins server container.
source ${SCRIPT_DIR}/jenkins-docker/createJenkins.sh

# Create Redmine server container.
source ${SCRIPT_DIR}/redmine-docker/createRedmine.sh

# Create Nginx proxy server container.
source ${SCRIPT_DIR}/nginx-docker/createNginx.sh

