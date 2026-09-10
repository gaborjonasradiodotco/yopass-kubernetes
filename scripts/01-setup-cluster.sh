#!/bin/bash
set -e

if minikube status -p yopass > /dev/null 2>&1; then
  echo "minikube profile yopass is already running, using that one."
else
  echo "Starting minikube..."
  minikube start -p yopass --driver=docker --nodes=3 --cpus=4 --memory=4096
fi

kubectl config use-context yopass

echo ""
echo "Enabling ingress..."
minikube addons enable ingress -p yopass

echo "Waiting for the ingress controller..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s

echo ""
echo "Enabling metrics-server..."
minikube addons enable metrics-server -p yopass
kubectl -n kube-system rollout status deployment/metrics-server --timeout=180s

echo ""
echo "Cluster is ready."
