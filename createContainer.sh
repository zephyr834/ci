#!/bin/bash

BASEDIR=$(readlink -f $(dirname $0))
SCRIPT_DIR=${BASEDIR}/img-scripts
NEXUS_DIR=nexus-docker
OPENLDAP_DIR=openldap-docker
GERRIT_DIR=gerrit-docker
JENKINS_DIR=jenkins-docker
REDMINE_DIR=redmine-docker
NGINX_DIR=nginx-docker
set -e

call_create_script() {
        SUBDIR=$1
        SCRIPT_NAME=$2
        echo "Current working dir is $(pwd)"
        cd ${SCRIPT_DIR}/${SUBDIR}
        source ${SCRIPT_NAME}
        cd ${BASEDIR}
}

# Add common variables.
source ${BASEDIR}/config
source ${BASEDIR}/config.default

# Create Nexus server.
if [ ${#NEXUS_WEBURL} -eq 0 ]; then
#    source ${SCRIPT_DIR}/nexus-docker/createNexus.sh
    call_create_script ${NEXUS_DIR} createNexus.sh
fi

# Create OpenLDAP server.
if [ ${#SLAPD_DOMAIN} -gt 0 -a ${#SLAPD_PASSWORD} -gt 0 ]; then
    ${SCRIPT_DIR}/openldap-docker/createOpenLDAP.sh ${SLAPD_PASSWORD} ${SLAPD_DOMAIN} ${GERRIT_ADMIN_UID} ${GERRIT_ADMIN_PWD} ${GERRIT_ADMIN_EMAIL}
#    call_create_script ${OPENLDAP_DIR} createOpenLDAP.sh
fi

# Create Gerrit server container.
#source ${SCRIPT_DIR}/gerrit-docker/createGerrit.sh
call_create_script ${GERRIT_DIR} createGerrit.sh

# Create Jenkins server container.
#source ${SCRIPT_DIR}/jenkins-docker/createJenkins.sh
call_create_script ${JENKINS_DIR} createJenkins.sh

# Create Redmine server container.
${SCRIPT_DIR}/redmine-docker/createRedmine.sh ${PG_REDMINE_NAME} ${POSTGRES_IMAGE} ${REDMINE_NAME} ${REDMINE_IMAGE_NAME} ${REDMINE_VOLUME} ${GERRIT_VOLUME}
#call_create_script ${REDMINE_DIR} createRedmine.sh

# Create Nginx proxy server container.
#source ${SCRIPT_DIR}/nginx-docker/createNginx.sh
call_create_script ${NGINX_DIR} createNginx.sh

