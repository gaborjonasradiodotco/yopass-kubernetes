.PHONY: check cluster cert deploy hosts proxy up status watch loadtest down

check:
	./scripts/00-check-prereqs.sh

cluster:
	./scripts/01-setup-cluster.sh

cert:
	./scripts/02-generate-tls-cert.sh

deploy:
	./scripts/03-deploy.sh

hosts:
	./scripts/04-add-hosts-entry.sh

proxy:
	sudo KUBECONFIG=$(HOME)/.kube/config kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 443:443 80:80

up: check cluster cert deploy hosts
	@echo ""
	@echo "Ready. Open https://yopass.radioco.local"

status:
	kubectl -n yopass get deploy,pods,svc,hpa,ingress

watch:
	while true; do clear; kubectl -n yopass get hpa,pods; sleep 2; done

loadtest:
	./scripts/05-load-test.sh

redis:
	kubectl -n yopass exec deploy/redis -- redis-cli DBSIZE

down:
	./scripts/99-teardown.sh
