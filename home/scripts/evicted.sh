#!/bin/sh

# remove evicted pods
kubectl get pods --all-namespaces -ojson | jq -r '.items[] | select(.status.reason!=null) | select(.status.reason | contains("Evicted")) | .metadata.name + " " + .metadata.namespace' | xargs -n2 -l bash -c 'kubectl delete pods $0 --namespace=$1'
