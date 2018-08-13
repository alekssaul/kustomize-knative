# kustomize-knative

Install kNative airgapped via kustomize

## Install Istio

Download [kustomize](https://github.com/kubernetes-sigs/kustomize/releases)

```sh
kustomize build ./istio/v0.1.0 | kubectl apply -f
```
