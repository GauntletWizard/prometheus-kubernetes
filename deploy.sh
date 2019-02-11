#!/bin/sh

# Assume namespace from kubectl context.

kubectl create configmap prometheus-rules --from-file=prometheus-rules/ --dry-run -o json | kubectl apply -f -
