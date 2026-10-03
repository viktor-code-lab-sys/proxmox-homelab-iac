# Atlantis

Merge-request driven Terraform: `atlantis plan` and `atlantis apply` as MR comments.

| File | Where it lives |
| --- | --- |
| `atlantis.yaml` | repository root of the infra repo |
| `repos.yaml.example` | Atlantis host, mounted as `/atlantis-data/repos.yaml` |
| `refresh-tf-secrets.sh` | Atlantis host; run before plan/apply |
| `docker-run.example.sh` | Atlantis host |

Gotchas that cost the most time:

- The GitLab token must be a **legacy** personal access token: fine-grained tokens
  cannot call the instance-level endpoints Atlantis needs at startup.
- GitLab blocks webhooks to private addresses by default; allow the Atlantis host
  under Admin → Settings → Network → Outbound requests.
- Push the branch before opening the MR: an MR with zero changes makes Atlantis give
  up polling the diff API.
