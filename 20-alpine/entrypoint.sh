#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purpose


#https://docs.docker.com/compose/startup-order/
if [ ! -z "${NODE_WAITFORIT_CONTAINER_NAME:-}" ] && [ ! -z "${NODE_WAITFORIT_CONTAINER_PORT:-}" ]; then
  #https://git.eeqj.de/external/mailinabox/commit/1d6793d12434a407d47efa7dc276f63227ad29e5
  if curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh --output /tmp/wait-for-it.sh -sS --fail > /dev/null 2>&1 ; then
    if [ "$(file -b --mime-type '/tmp/wait-for-it.sh')" == "text/x-shellscript" ]; then
      chmod +x /tmp/wait-for-it.sh;
      /tmp/wait-for-it.sh ${NODE_WAITFORIT_CONTAINER_NAME}:${NODE_WAITFORIT_CONTAINER_PORT} -t 0;
    fi
    rm /tmp/wait-for-it.sh;
  fi
fi


IFS=',' read -ra libs <<< "${NODE_NPM_GLOBAL_LIBS}";
for lib in "${libs[@]}"
do
  runuser -l node -c "PATH=$PATH; npm install -g ${lib}";
done

IFS=',' read -ra paths <<< "${NODE_NPM_PATHS}";
for path in "${paths[@]}"
do
  if [ "${NODE_ENV}" = "development" ]; then
    runuser -l node -c "PATH=$PATH; cd ${path}; npm install";
  else
    runuser -l node -c "PATH=$PATH; cd ${path}; npm install --only=production";
  fi
done


####

#https://stackoverflow.com/a/46433245/3929620
. /docker-entrypoint.sh
