#!/bin/sh

# This doesn't do much for now

# Split istio
version="v0.1.0"

case "$version" in
"v0.1.0")
    istioversion="0.8.0"
    knativeversion="v0.1.0"
    ;;
*)
    echo "Version not supported"
    exit 1
    ;;
esac

istiobase="https://raw.githubusercontent.com/istio/istio/$istioversion/install/kubernetes/helm/"
istiourl="https://raw.githubusercontent.com/knative/serving/$version/third_party/istio-$istioversion/istio.yaml"
knativeurl="https://github.com/knative/serving/releases/download/$knativeversion/release.yaml"

echo "Downloading kNative version: " $knativeversion " and istio :" $istioversion

istiourls=$(curl -s $istiourl | grep "Source" | awk -F ': ' '{print $2}')

for i in $istiourls
do
   : 
   echo $istiobase/$i
done