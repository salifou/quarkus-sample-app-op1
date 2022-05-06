#/bin/bash

oc new-project dev-demo-pipeline 2> /dev/null

oc apply                            \
    -f provided/secrets.yaml        \
    -f provided/pvcs.yaml           \
    -f tasks/update-app-config.yaml \
    -f tasks/build-image.yaml       \
    -f pipeline.yaml                \
    --dry-run=client

### Link secret to pipeline sa
oc secrets link pipeline quarkus-demo-app-ssh
oc secrets link pipeline quarkus-demo-config-ssh
oc secrets link pipeline quayio

### Run the pipeline
tkn pipeline start \
--showlog \
--prefix-name=demo-pipeline \
--param APP_REPO_GIT_URL=git@github.com:ssmalick/quarkus-demo.git \
--param APP_REPO_GIT_REVISION=main \
--param CONFIG_REPO_GIT_URL=git@github.com:ssmalick/quarkus-demo-config.git \
--param IMAGE_NAME=quarkus-demo \
--param IMAGE_REPO=quay.io/ssm \
--workspace name=source,claimName=pipeline-pvc \
--workspace name=app-ssh-credentials,secret=quarkus-demo-app-ssh \
--workspace name=config-ssh-credentials,secret=quarkus-demo-config-ssh \
--workspace name=maven-repo,emptyDir= \
dev-demo-pipeline

# # --param IMAGE_REPO=image-registry.openshift-image-registry.svc:5000/dev-quarkus-demo
