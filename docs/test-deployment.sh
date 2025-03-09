#!/bin/bash
# installing kubectx and kubens is recommended
# use gcloud to authenticate to kubernetes cluster
# like gcloud container clusters get-credentials florenciacomuzzi-cluster-prod --region us-east1 --project florenciacomuzzi
kubectl create deployment pingtest --image=busybox --replicas=3 -- sleep infinity