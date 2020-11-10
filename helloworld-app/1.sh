#!/bin/bash

gcloud container clusters get-credentials cluster-1 --zone us-central1-c --project jenkins-2020-292615


#kubectl apply -f ingress.yaml
kubectl apply -f Deployment.yaml
#kubectl apply -f nginx-ingress-controller-mandatory.yaml
