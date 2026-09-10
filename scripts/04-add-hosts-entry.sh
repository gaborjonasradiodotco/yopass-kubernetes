#!/bin/bash
set -e

IP=$(minikube ip -p yopass)
echo "minikube ip is $IP"

if curl -s -o /dev/null --max-time 3 http://$IP; then
  echo "$IP works, using it."
else
  echo "$IP does not answer (normal on mac/windows), using 127.0.0.1."
  echo "Don't forget to run 'make proxy' in another terminal and leave it open,"
  IP=127.0.0.1
fi

if grep -q yopass.radioco.local /etc/hosts; then
  echo "Removing the old /etc/hosts line..."
  sudo sed -i.bak "/yopass.radioco.local/d" /etc/hosts
fi

echo "Adding the new line to /etc/hosts (needs sudo)..."
echo "$IP yopass.radioco.local" | sudo tee -a /etc/hosts > /dev/null

echo "Done. Try: curl -i https://yopass.radioco.local/"
