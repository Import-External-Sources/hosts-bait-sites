#!/bin/bash
# This hosts file for DD-WRT Routers with DNSMasq is brought to you by 
# https://www.mypdns.org/
# Copyright: Content: https://gitlab.com/spirillen
# Source:Content: 
#
# Original attributes and credit
# This hosts file for DD-WRT Routers with DNSMasq is brought to you by Mitchell Krog
# Copyright:Code: https://github.com/mitchellkrogza
# Source:Code: https://github.com/mitchellkrogza/Badd-Boyz-Hosts
# The credit for the original bash scripts goes to Mitchell Krogza

# You are free to copy and distribute this file for non-commercial uses,
# as long the original URL and attribution is included. 

# Please forward any additions, corrections or comments by logging an issue at
# https://gitlab.com/my-privacy-dns/support/issues

# **********************************
# Setup input bots and referer lists
# **********************************

input1=${TRAVIS_BUILD_DIR}/PULL_REQUESTS/domains.txt

# *********************************************
# Get Travis CI Prepared for Committing to Repo
# *********************************************

PrepareTravis () {
    git remote rm origin
    git remote add origin https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git
    git config --global user.email "${GIT_EMAIL}"
    git config --global user.name "${GIT_NAME}"
    git config --global push.default simple
    git checkout "${GIT_BRANCH}"
    ulimit -u
}
PrepareTravis

# **************************************************************************
# Sort lists alphabetically and remove duplicates before cleaning Dead Hosts
# **************************************************************************

PrepareLists () {

    wget -qO- "https://gitlab.com/my-privacy-dns/matrix/matrix/raw/master/source/bait_sites/wildcard.list" >> ${input1}

    sort -u -f ${input1} -o ${input1}
    dos2unix ${input1}
 }
PrepareLists

# ***********************************
# Deletion of all whitelisted domains
# ***********************************

WhiteListing () {
    if [[ "$(git log -1 | tail -1 | xargs)" =~ "ci skip" ]]
        then
            hash uhb_whitelist
            uhb_whitelist -f "${input1}" -o "${input1}"
    fi
}
WhiteListing

exit ${?}
