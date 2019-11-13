#!/bin/bash

git clone https://github.com/semaphoreci/toolbox.git ~/.toolbox
bash ~/.toolbox/install-toolbox
source ~/.toolbox/toolbox

checkout

BRANCH=${SEMAPHORE_GIT_BRANCH}
ZEPHYR_SDK_INSTALL_DIR=/opt/sdk/zephyr-sdk-0.10.3
ZEPHYR_TOOLCHAIN_VARIANT=zephyr

./scripts/ci/run_ci.sh -c -b ${BRANCH} -r origin -m ${MATRIX_BUILD} -M ${MATRIX_BUILDS};
./scripts/ci/run_ci.sh -s -b ${BRANCH} -r origin -m ${MATRIX_BUILD} -M ${MATRIX_BUILDS};

