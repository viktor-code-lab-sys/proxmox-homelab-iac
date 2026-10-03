# Monitoring: kube-prometheus-stack

```bash
# Mirror host: chart into the registry as an OCI artifact
../../supply-chain/mirror-chart.sh prometheus-community https://prometheus-community.github.io/helm-charts kube-prometheus-stack 66.2.1

# Cluster
kubectl create namespace monitoring
kubectl create secret docker-registry harbor-pull-secret -n monitoring \
  --docker-server=registry.homelab.example \
  --docker-username='robot$containerd-pull' --docker-password='<robot secret>'
kubectl create secret generic grafana-admin -n monitoring \
  --from-literal=admin-user=admin --from-literal=admin-password='<from Vault>'
helm install monitoring oci://registry.homelab.example/helm-charts/kube-prometheus-stack \
  --version 66.2.1 -n monitoring -f values.yaml
../platform/patch-pull-secrets.sh monitoring
```

Grafana's admin password comes from an existing secret instead of the values file,
so `values.yaml` holds no credentials.
