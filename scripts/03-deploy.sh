#!/bin/bash
set -e

kubectl apply -f k8s/namespace.yaml

echo "Applying the yaml files..."
kubectl apply -f k8s/redis/
kubectl apply -f k8s/yopass/

echo ""
echo "Waiting for redis..."
kubectl -n yopass rollout status deployment/redis --timeout=120s

echo "Waiting for yopass..."
kubectl -n yopass rollout status deployment/yopass --timeout=120s

echo ""
kubectl -n yopass get deploy,pods,svc,hpa,ingress

echo ""
echo "Next: ./scripts/04-add-hosts-entry.sh"
echo "Then open https://yopass.radioco.local"
