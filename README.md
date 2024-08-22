# Using Keycloak to enable SSO authentication in ArgoCD Web UI

Inspired by article <https://medium.com/@charled.breteche/kind-keycloak-and-argocd-with-sso-9f3536dd7f61> with changes for 2024 year

## Requirements

- docker
- kubectl
- kind cli
- helm
- terraform cli

## Setup kubernetes cluster

Run `./cluster-setup.sh` and you got 3 control-plane nodes and 3 worker nodes kubernetes cluster with installed cilium CNI, cert-manager, ingress-nginx, metallb and 4 proxy image repository in docker containers in one network

## Deploy Keycloak

Run `./deploy-keycloak.sh`

## Configure Keycloak

Run `terraform init` and then `terraform apply -auto-approve`

## Deploy ArgoCD

Run `deploy-argocd.sh`

## Access to ArgoCD Web UI

In browser open `http://argocd.kind.cluster`

You will be redirected to keycloak authorization page.

Enter login and password `user-admin/user-admin` and you will be redirected back to Argo CD UI.

## Deploy app using ArgoCD

Argo CD application page is empty. Lets deploy something.

Run `kubectl apply -f metrics-server.yaml`

After a while metrics-server resources appears in UI.
