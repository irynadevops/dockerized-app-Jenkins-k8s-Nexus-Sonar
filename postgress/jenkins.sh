#! /bin/bash

gcloud container clusters get-credentials cluster-1 --zone us-central1-c --project jenkins-2020-292615

kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/provider/cloud-generic.yaml



kubectl apply -f postgres-config.yaml
kubectl apply -f postgres-pv-claim.yaml
kubectl apply -f postgres-deploy.yaml


