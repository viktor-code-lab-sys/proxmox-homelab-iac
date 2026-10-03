# Nextcloud (air-gapped namespace)

```bash
kubectl apply -f nextcloud.yaml   # creates the namespace first
kubectl create secret generic nextcloud-secrets -n nextcloud \
  --from-literal=postgres-password='<from Vault>' \
  --from-literal=nextcloud-admin-password='<from Vault>'
kubectl create secret docker-registry harbor-pull-secret -n nextcloud \
  --docker-server=registry.homelab.example \
  --docker-username='robot$containerd-pull' --docker-password='<robot secret>'

# The namespace has no internet by design; stop Nextcloud from trying.
kubectl exec -n nextcloud deploy/nextcloud -- su -s /bin/sh www-data -c \
  "php occ config:system:set has_internet_connection --value=false --type=boolean"
```

Major versions cannot be skipped on upgrade. A fresh instance without data is simpler
to recreate (delete the Deployment, StatefulSet and both PVCs, apply again).
