# Demo pipeline


## Folder Structure

- **provided**: Resource (secret, pvc etc.) provided for each app. DO NEED TO BE HERE

- **tasks**: Namespaced tasks used in pipelines

- **dev-pipeline**: CI pipeline for DEV


## Dev Pipeline

**Steps**

1. Clone the application repo
2. Build the source
3. Build and push the container image to remote repository
4. Update application config
   1. Clone the config repo
   2. Update the container image digest in the deployment
   3. [Optional] Save application repo git commit (e.g annotation, file etc)
   4. Commit and push the config repo
5. [TODO] Trigger ArgoCD sync 


## Higher Env pipeline (e.g TEST, QA, PROD)

**Steps**

1. Get container digest currently running in lower env
2. Clone the config repo
3. Copy the config from lower environment
4. Commit and push the config repo
5. Create a PR


This pipeline can also deploy a specific container image digest
