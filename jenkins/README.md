# Jenkins: node_exporter rollout

A parameterised pipeline that installs Prometheus node_exporter on service VMs over
SSH, pulling the binary from the internal registry with ORAS. Re-running it is safe:
hosts that already answer on the expected port are skipped.

Setup in Jenkins:

1. Plugins: Pipeline, SSH Agent, Pipeline Utility Steps (`readJSON`). In an air-gapped
   setup download the `.hpi` files on the mirror host and upload them under
   Manage Jenkins → Plugins → Advanced → Deploy Plugin.
2. Credentials: `jenkins-automation-key` (SSH username with private key, user `admin`)
   and `harbor-robot-secret` (secret text).
3. Job: Pipeline script from SCM → this repository → `jenkins/Jenkinsfile`.

The target VMs need `oras` and `curl`; the public key of `jenkins-automation-key`
goes into `~admin/.ssh/authorized_keys`.
