# GitHub Actions runner image

This repository builds the shared container image used by GitHub Actions Runner
Controller (ARC) in the home K3s cluster. It combines GitHub's official Ubuntu
Slim environment with the official Actions runner.

The inputs are fixed for reproducible rebuilds:

- `actions/runner-images` Ubuntu Slim `20260728.2` at commit
  `eac270ed77ebb2e5896c8df1a13f81fbd71ed3b7`
- Go `1.24.13`, the fixed `ubuntu-24.04` default at that runner-images commit
- `ghcr.io/actions/actions-runner:2.336.0`

Run **Build Actions runner image** manually in GitHub Actions. The workflow
publishes `ghcr.io/yunwei37/github-actions-runner` and records its immutable
digest in the run summary. Runtime manifests should always use that digest,
not the mutable version tag.
