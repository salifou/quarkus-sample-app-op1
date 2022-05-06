#/bin/bash

set -e

oc new-project dev-quarkus-demo-pipeline 2> /dev/null || true # ignore error

oc apply                            \
    -f provided/secrets.yaml        \
    -f provided/pvcs.yaml           \
    -f tasks/update-app-config.yaml \
    -f tasks/build-image.yaml       \
    -f dev-pipeline.yaml

### Link secret to pipeline sa
oc secrets link pipeline ssm-github-ssh
oc secrets link pipeline ssm-quayio

### Run the pipeline
tkn pipeline start \
--showlog \
--prefix-name=demo-pipeline \
--param GIT_URL=git@github.com:salifou/quarkus-sample-app-op1.git \
--param GIT_REVISION=main \
--param APP_SRC_PATH=quarkus-demo \
--param APP_CONFIG_PATH=k8s-resources/kustomize \
--param IMAGE_NAME=quarkus-demo \
--param IMAGE_REPO=quay.io/ssm \
--workspace name=source,claimName=pipeline-pvc \
--workspace name=ssh-directory,secret=ssm-github-ssh \
--workspace name=maven-repo,emptyDir= \
dev-quarkus-demo-pipeline

# # --param IMAGE_REPO=image-registry.openshift-image-registry.svc:5000/dev-quarkus-demo
