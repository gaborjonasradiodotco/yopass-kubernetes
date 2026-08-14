# Yopass on Kubernetes

Yopass in minikube, with Redis as the backend,
 2 pods scaling up to 5 under load

```
k8s/         the yaml files (namespace, redis, yopass, hpa, ingress)
loadtest/    a k6 script that makes a lot of requests so the autoscaler kicks in
scripts/     helper scripts, run them in order (00 ... 05)
Makefile     short commands for the scripts
```

## Run it

Needs Docker, minikube, kubectl and mkcert. Run everything from the repo root
(the scripts use paths like `k8s/namespace.yaml`).

```bash
make check     # check the tools are installed
make up        # cluster + certificate + deploy + /etc/hosts entry
make proxy     # macOS only, in a second terminal, leave it running
```

`make` on its own lists all commands, including the individual steps
(`make cluster`, `make cert`, `make deploy`, `make hosts`) if you only want to
redo one part.

Then open https://yopass.radioco.local. There should be no certificate warning,
mkcert issues one your computer trusts.

## Load test and autoscaling

```bash
make watch      # one terminal: kubectl -n yopass get hpa,pods -w
make loadtest   # another terminal: k6, ~3 minutes, up to 150 VUs
```

You should see CPU rise in the hpa and pods go from 2 to 5, then back to 2 a few
minutes after the test (the hpa waits before scaling down).
## Cleanup

```bash
make down
```
