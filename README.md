# kustomize-knative

Install kNative airgapped via kustomize

## Install Istio

Download [kustomize](https://github.com/kubernetes-sigs/kustomize/releases)

Fetch images, re-tag and push to an internal repo

```sh
# Set New Repo name in syntax of DOMAIN/REPO
export repo=docker.io/alekssaul
./scripts/images.sh
```

Run Kustomize against istio

```sh
kustomize build ./istio/v0.1.0 | kubectl apply -f
```
