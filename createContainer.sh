#!/bin/bash
set -e

BASEDIR=$(readlink -f $(dirname $0))

# Add common variables.
source ${BASEDIR}/config
source ${BASEDIR}/config.default

# Create Nexus server.
if [ ${#NEXUS_WEBURL} -eq 0 ]; then
    source ~/nexus-docker/createNexus.sh
fi

# Create OpenLDAP server.
if [ ${#SLAPD_DOMAIN} -gt 0 -a ${#SLAPD_PASSWORD} -gt 0 ]; then
    source ~/openldap-docker/createOpenLDAP.sh
fi

# Create Gerrit server container.
source ~/gerrit-docker/createGerrit.sh

# Create Jenkins server container.
source ~/jenkins-docker/createJenkins.sh

# Create Redmine server container.
source ~/redmine-docker/createRedmine.sh

# Create Nginx proxy server container.
source ~/nginx-docker/createNginx.sh

