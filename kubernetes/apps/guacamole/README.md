# Apache Guacamole 1.6.0

The database schema must exist before the first start. Generate it on the mirror
host (the only machine with Docker and internet) and ship it as an OCI artifact:

```bash
docker run --rm guacamole/guacamole:1.6.0 /opt/guacamole/bin/initdb.sh --postgresql > guac-initdb.sql
../../../supply-chain/mirror-file.sh guac-initdb.sql guac-initdb 1.6.0 application/sql
```

On the cluster:

```bash
oras pull registry.homelab.example/k8s-binaries/guac-initdb:1.6.0
kubectl apply -f guacamole.yaml
kubectl create configmap guac-initdb -n guacamole --from-file=initdb.sql=guac-initdb.sql
kubectl create secret generic guacamole-secrets -n guacamole --from-literal=postgres-password='<from Vault>'
```

Change the default `guacadmin` password right after the first login.
