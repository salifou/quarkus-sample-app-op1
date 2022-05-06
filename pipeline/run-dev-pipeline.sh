#/bin/bash

oc new-project dev-quarkus-demo-pipeline 2> /dev/null

oc apply                            \
    -f provided/secrets.yaml        \
    -f provided/pvcs.yaml           \
    -f tasks/update-app-config.yaml \
    -f tasks/build-image.yaml       \
    -f pipeline.yaml

### Link secret to pipeline sa
oc secrets link pipeline ssm-github-ssh
oc secrets link pipeline ssm-quayio

### Run the pipeline
tkn pipeline start \
--showlog \
--prefix-name=demo-pipeline \
--param APP_REPO_GIT_URL=git@github.com:salifou/quarkus-sample-app-op1.git \
--param APP_REPO_GIT_REVISION=main \
--param CONFIG_REPO_GIT_URL=git@github.com:salifou/quarkus-sample-app-op1.git \
--param CONFIG_OVERLAY=k8s-resources/kustomize/overlays/dev \
--param IMAGE_NAME=quarkus-demo \
--param IMAGE_REPO=quay.io/ssm \
--workspace name=source,claimName=pipeline-pvc \
--workspace name=app-ssh-credentials,secret=ssm-github-ssh \
--workspace name=config-ssh-credentials,secret=ssm-github-ssh \
--workspace name=maven-repo,emptyDir= \
dev-quarkus-demo-pipeline

# # --param IMAGE_REPO=image-registry.openshift-image-registry.svc:5000/dev-quarkus-demo
