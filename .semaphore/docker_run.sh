#!/bin/bash
set -exo pipefail

source ~/.toolbox/toolbox
source /tmp/.env

export ZEPHYR_SDK_INSTALL_DIR=/opt/sdk/zephyr-sdk-0.10.3
export ZEPHYR_TOOLCHAIN_VARIANT=zephyr

if [ "${SEMAPHORE_GIT_REF_TYPE}" = "pull-request" ]; then
    IS_PULL_REQUEST="true";
    PULL_REQUEST_BASE_BRANCH=${SEMAPHORE_GIT_PR_BRANCH}
    PULL_REQUEST=${SEMAPHORE_GIT_PR_NUMBER}
else
    IS_PULL_REQUEST="false";
    BRANCH=${SEMAPHORE_GIT_BRANCH}
fi;

cd ${HOME}/${SEMAPHORE_PROJECT_NAME}

# Build
if [ "${IS_PULL_REQUEST}" = "true" ]; then
    ./scripts/ci/run_ci.sh -c -b ${PULL_REQUEST_BASE_BRANCH} -r origin -m ${MATRIX_BUILD} -M ${MATRIX_BUILDS} -p ${PULL_REQUEST};
else
    ./scripts/ci/run_ci.sh -c -b ${BRANCH} -r origin -m ${MATRIX_BUILD} -M ${MATRIX_BUILDS};
fi;

SUCCESS=$?

if [ ${SUCCESS} -eq 0 ]; then
# On success
    if [ "${IS_PULL_REQUEST}" = "true" ]; then
        ./scripts/ci/run_ci.sh -s -b ${PULL_REQUEST_BASE_BRANCH} -r origin -m ${MATRIX_BUILD} -M ${MATRIX_BUILDS} -p ${PULL_REQUEST};
    else
        ./scripts/ci/run_ci.sh -s -b ${BRANCH} -r origin -m ${MATRIX_BUILD} -M ${MATRIX_BUILDS};
    fi;
else
# On failure
    if [ "${IS_PULL_REQUEST}" = "true" ]; then
        ./scripts/ci/run_ci.sh -f -b ${PULL_REQUEST_BASE_BRANCH} -r origin -m ${MATRIX_BUILD} -M ${MATRIX_BUILDS} -p ${PULL_REQUEST};
    else
        ./scripts/ci/run_ci.sh -f -b ${BRANCH} -r origin -m ${MATRIX_BUILD} -M ${MATRIX_BUILDS};
    fi;    
fi
