#!/bin/bash

echo "Checking tools..."

ok=1

if command -v docker > /dev/null; then
  echo "docker: ok"
else
  echo "docker: MISSING - https://docs.docker.com/get-docker/"
  ok=0
fi

if command -v minikube > /dev/null; then
  echo "minikube: ok"
else
  echo "minikube: MISSING - https://minikube.sigs.k8s.io/docs/start/"
  ok=0
fi

if command -v kubectl > /dev/null; then
  echo "kubectl: ok"
else
  echo "kubectl: MISSING - https://kubernetes.io/docs/tasks/tools/"
  ok=0
fi

if command -v mkcert > /dev/null; then
  echo "mkcert: ok"
else
  echo "mkcert: MISSING - https://github.com/FiloSottile/mkcert (needed for https)"
  ok=0
fi

if [ $ok = 0 ]; then
  echo ""
  echo "Please install the missing tools and run this again."
  exit 1
fi

echo ""
echo "All good."
