#!/bin/bash
set -e

mkdir -p certs

echo "Installing the mkcert CA (if it is not there yet)..."
mkcert -install

echo "Making the certificate..."
mkcert -cert-file certs/yopass.radioco.local.pem \
       -key-file certs/yopass.radioco.local-key.pem \
       yopass.radioco.local

echo "Creating the namespace..."
kubectl apply -f k8s/namespace.yaml

echo "Putting the certificate in the cluster..."

kubectl -n yopass create secret tls yopass-tls \
  --cert=certs/yopass.radioco.local.pem \
  --key=certs/yopass.radioco.local-key.pem \
  --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "Done.
