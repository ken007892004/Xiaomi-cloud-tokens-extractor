#!/usr/bin/env bash
ha_host=$(ha network info --raw-json 2>/dev/null | jq ".data.interfaces[0].ipv4.address[0]" 2>/dev/null | sed "s/\/.*//g" 2>/dev/null | sed "s/\"//g" 2>/dev/null)
if [ -z "${ha_host}" ]; then
  ha_host="127.0.0.1"
fi
host_to_pass=$ha_host || "127.0.0.1"
set -o errexit  # fail on first error
set -o nounset  # fail on undef var
set -o pipefail # fail on first error in pipe

curl --silent --fail --show-error --location --remote-name --remote-header-name\
  https://github.com/PiotrMachowski/Xiaomi-cloud-tokens-extractor/releases/latest/download/token_extractor_docker.zip
unzip token_extractor_docker.zip
cd token_extractor_docker
docker_image=$(docker build -q .)
docker run --rm -it -p 31415:31415 $docker_image --host $host_to_pass
docker rmi $docker_image
cd ..
rm -rf token_extractor_docker token_extractor_docker.zip
