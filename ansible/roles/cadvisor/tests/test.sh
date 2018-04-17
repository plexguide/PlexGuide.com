#!/bin/bash -e
ansible-playbook -t cadvisor_docker_testing ./test.yml -vv
docker-compose -f ./output/docker-compose.yml config > /dev/null
[[ $(docker ps --filter status=running --filter name="^/output_cadvisor_1" -q | wc -l) -eq 1 ]]
