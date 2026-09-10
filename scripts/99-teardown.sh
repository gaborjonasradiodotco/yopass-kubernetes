#!/bin/bash

if minikube status -p yopass > /dev/null 2>&1; then
  minikube delete -p yopass
  echo "minikube profile yopass deleted."
else
  echo "There is no minikube profile called yopass."
fi

echo ""
echo "stop 'make proxy' if it is still running, and remove"
echo "the yopass.radioco.local line from /etc/hosts."
