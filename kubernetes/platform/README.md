# Cluster platform add-ons

Installed in this order. Every manifest is fetched on the mirror host, stored in the
registry as an OCI artifact (`../../supply-chain/mirror-file.sh`) and pulled onto the
cluster; image references are rewritten to the registry's proxy-cache projects.

| Add-on | Version | Image source rewrite |
| --- | --- | --- |
| local-path-provisioner | v0.0.30 | `rancher/` → `<registry>/dockerhub-proxy/rancher/` |
| ingress-nginx (baremetal) | controller-v1.11.3 | `registry.k8s.io/ingress-nginx/` → `<registry>/k8s-proxy/ingress-nginx/` |
| cert-manager | v1.16.2 | `quay.io/jetstack/` → `<registry>/quay-proxy/jetstack/` |

```bash
# ingress-nginx: fixed NodePorts, so the firewall load balancer has stable targets
kubectl patch svc ingress-nginx-controller -n ingress-nginx -p '{"spec":{"ports":[
  {"name":"http","port":80,"targetPort":"http","nodePort":30080,"protocol":"TCP"},
  {"name":"https","port":443,"targetPort":"https","nodePort":30443,"protocol":"TCP"}]}}'

# local-path as the default StorageClass
kubectl patch storageclass local-path \
  -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Vault issuer
kubectl create secret generic cert-manager-vault-approle -n cert-manager --from-literal=secretId='<SECRET_ID>'
sed "s|<BASE64_FULL_CA_CHAIN>|$(base64 -w0 full-ca-chain.pem)|; s|<CERT_MANAGER_ROLE_ID>|<role-id>|" \
  cluster-issuer.yaml | kubectl apply -f -
```

Prerequisite on a "hard way" cluster: control-plane nodes must run kube-proxy (with
`nf_conntrack` loaded and `ip_forward=1`). Without it the API server cannot reach any
Service ClusterIP, and every admission webhook times out.
