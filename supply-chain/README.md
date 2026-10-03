# Air-gapped supply chain

Rule: only the mirror host talks to the internet. Everything else pulls from it.

| Artifact | Mechanism | Script |
| --- | --- | --- |
| Debian packages | apt-cacher-ng | — |
| Container images | registry proxy-cache projects (Docker Hub, registry.k8s.io, quay.io) | `mirror-image.sh` (optional pre-warm) |
| Helm charts | OCI artifacts in `helm-charts` | `mirror-chart.sh` |
| Binaries, manifests, SQL, ISOs | OCI artifacts in `k8s-binaries` via ORAS | `mirror-binary.sh`, `mirror-file.sh` |

The first tool on a fresh VM (`oras` itself) cannot come through ORAS; copy it once
from the mirror host with `scp`.

Example:

```bash
export ROBOT_SECRET='...'
./mirror-binary.sh \
  https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz \
  node_exporter v1.8.2
```

Note: `oras pull` restores the file under the name it was pushed with, so scripts on
the consumer side must use that exact name.
