#!/bin/bash
set -e

echo ""
echo "Running k6 in the cluster..."

kubectl -n yopass create configmap k6-script \
  --from-file=k6-script.js=loadtest/k6-script.js \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl -n yopass delete job k6-load-test --ignore-not-found

kubectl apply -f loadtest/k6-job.yaml

kubectl -n yopass wait --for=condition=ready pod -l job-name=k6-load-test --timeout=60s
kubectl -n yopass logs -f job/k6-load-test

echo ""
echo "Now check:"
echo "  kubectl -n yopass get hpa"
echo "  kubectl -n yopass get pods"
