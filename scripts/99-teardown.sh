#!/bin/bash

if minikube status -p yopass-poc > /dev/null 2>&1; then
  minikube delete -p yopass-poc
  echo "minikube profile yopass-poc deleted."
else
  echo "There is no minikube profile called yopass-poc."
fi

echo ""
echo "stop 'make proxy' if it is still running, and remove"
echo "the yopass.radioco.local line from /etc/hosts."
