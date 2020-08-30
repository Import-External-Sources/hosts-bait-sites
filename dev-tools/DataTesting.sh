#!/bin/bash
# **********************
# Run PyFunceble Testing
# **********************
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza

set -e

# ****************************************************************
# This uses the awesome PyFunceble script created by Nissar Chababy
# Find funceble at: https://github.com/funilrys/PyFunceble
# ****************************************************************

# **********************
# Setting date variables
# **********************

yeartag=$(date +%Y)
monthtag=$(date +%m)

# ******************
# Set our Input File
# ******************
input=${TRAVIS_BUILD_DIR}/PULL_REQUESTS/domains.txt

RunFunceble () {

    yeartag=$(date +%Y)
    monthtag=$(date +%m)
    #ulimit -u
    cd ${TRAVIS_BUILD_DIR}/dev-tools

    hash PyFunceble

    #if [[ -f "${pyfuncebleConfigurationFileLocation}" ]]
    #then
    #    rm "${pyfuncebleConfigurationFileLocation}"
    #    rm "${pyfuncebleProductionConfigurationFileLocation}"
    #fi

    PyFunceble --ci -q -h -m -p $(nproc --ignore=1) -db \
        --database-type mariadb -ex --plain --dns 127.0.0.1 \
        --autosave-minutes 20 --share-logs --idna \
        --hierarchical --ci-branch master \
        --ci-distribution-branch master  \
        --cmd-before-end "bash ${TRAVIS_BUILD_DIR}/dev-tools/FinalCommit.sh" \
        -f "https://gitlab.com/my-privacy-dns/matrix/matrix/raw/master/source/bait_sites/wildcard.list"
}

RunFunceble


exit ${?}
