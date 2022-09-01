#!/bin/bash

# set envs for test
# ./scripts/generate-values.sh -t
if [ "$1" == "-t" ]; then
  export cpu_requests=10
  export memory_requests=20
fi

# get appVersion(service-exchange version) and version.sh
VERSIONS=`bash ./scripts/chart-service-exchange-version.sh`
if [ $? -eq 0 ]; then
  export ${VERSIONS}
else
  # echo error message
  echo ${VERSIONS}
  exit 1
fi

if [ -z "${TRAVIS_TAG}" ];then
  BRANCH="master"
else
  BRANCH=${appVersion}
fi
curl -O https://raw.githubusercontent.com/service-exchange/service-exchange/${BRANCH}/deploy/version.sh

# get versions and images from version.sh
OP_VERSIONS_IMAGES=`bash version.sh service-exchange-${appVersion}`
if [ $? -eq 0 ]; then
  export ${OP_VERSIONS_IMAGES}
else
  # echo error message
  echo ${OP_VERSIONS_IMAGES}
  exit 1
fi

# At first, you should install handlerbars impl with by pybars3, git-repo: git@github.com:wbond/pybars3.git
python ./scripts/handlebars-render.py -i ./templates/values.yaml.handlebars -v ./templates/config.json -o ./service-exchange/values.yaml -e
python ./scripts/handlebars-render.py -i ./templates/Chart.yaml.handlebars -v ./templates/config.json -o ./service-exchange/Chart.yaml -e
