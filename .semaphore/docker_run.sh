#!/bin/bash

docker run --env-file env_variables \
--privileged=true \
--tty \
--net=bridge \
--user buildslave \
-v /var/run/docker.sock:/var/run/docker.sock \
