#!/bin/bash

# Exit on any command that exits with exit code != 0
set -e

OPENLDAP_URL=${OPENLDAP_URL:-https://github.com/shivshav/openldap-docker.git}
OPENLDAP_BRANCH=${OPENLDAP_BRANCH}

REDMINE_URL=${REDMINE_URL:-https://github.com/shivshav/redmine-docker.git}
REDMINE_BRANCH=${REDMINE_BRANCH}

JENKINS_URL=${JENKINS_URL:-https://github.com/shivshav/jenkins-docker.git}
JENKINS_BRANCH=${JENKINS_BRANCH}

JENKINS_SLAVE_URL=${JENKINS_SLAVE_URL:-https://github.com/openfrontier/jenkins-slave-docker.git}
JENKINS_SLAVE_BRANCH=${JENKINS_SLAVE_BRANCH}

GERRIT_URL=${GERRIT_URL:-https://github.com/shivshav/gerrit-docker.git}
GERRIT_BRANCH=${GERRIT_BRANCH}

NEXUS_URL=${NEXUS_URL:-https://github.com/shivshav/nexus-docker.git}
NEXUS_BRANCH=${NEXUS_BRANCH}

DOKUWIKI_URL=${DOKUWIKI_URL:-https://github.com/shivshav/dokuwiki-docker.git}
DOKUWIKI_BRANCH=${DOKUWIKI_BRANCH}

NGINX_URL=${NGINX_URL:-https://github.com/shivshav/nginx-docker.git}
NGINX_BRANCH=${NGINX_BRANCH}

set_submodule(){ # (submodule_directory_name, submodule_url, [submodule_branch])
    # We need 2-3 arguments to the script
    if [[ $# -lt 2 || $# -gt 3 ]]; then
        >&2 echo "Incorrect number of arguments provided to submodule config"
        exit 1
    fi

    SUBMODULE_DIR=$1
    SUBMODULE_URL=$2
    SUBMODULE_BRANCH=$3
    # Set the new submodule URL
    git config --file=.gitmodules submodule.img-scripts/${SUBMODULE_DIR}.url ${SUBMODULE_URL}
    echo "Set submodule for ${SUBMODULE_DIR} to ${SUBMODULE_URL}"
    # Set the submodule branch if provided
    if [ -n "$SUBMODULE_BRANCH" ]; then
        git config --file=.gitmodules submodule.img-scripts/${SUBMODULE_DIR}.branch ${SUBMODULE_BRANCH}
        echo "Set branch for ${SUBMODULE_DIR} to ${SUBMODULE_BRANCH}"
    else # unset otherwise
        # If no branch was set, the command exits with code 5, which we don't care about so we reset 'set -e'
        set +e 
        git config --file=.gitmodules --unset-all submodule.img-scripts/${SUBMODULE_DIR}.branch
        echo "No branch specified. Using default branch"
        set -e
    fi
}


# Do submodule config stuff
set_submodule openldap-docker ${OPENLDAP_URL} ${OPENLDAP_BRANCH}
set_submodule redmine-docker ${REDMINE_URL} ${REDMINE_BRANCH}
set_submodule jenkins-docker ${JENKINS_URL} ${JENKINS_BRANCH}
set_submodule jenkins-slave-docker ${JENKINS_SLAVE_URL} ${JENKINS_SLAVE_BRANCH}
set_submodule gerrit-docker ${GERRIT_URL} ${GERRIT_BRANCH}
set_submodule nexus-docker ${NEXUS_URL} ${NEXUS_BRANCH}
#set_submodule dokuwiki-docker ${DOKUWIKI_URL} ${DOKUWIKI_BRANCH} FOR FUTURE USE
set_submodule nginx-docker ${NGINX_URL} ${NGINX_BRANCH}


# If we are building a pull-request, use the developer-provided submodule
# This way, even if travis.yml contains env variables set by the developer
# we can circumvent the changes if necessary
if [ "${TRAVIS_PULL_REQUEST}" = "true" ]; then

    # Finally update the submodule from the new remotes
    git submodule update --init --recursive --remote
    echo "Submodule updated!"
else
    echo "Not a pull request, using default repositories..."
    git submodule update --init --recursive
fi
