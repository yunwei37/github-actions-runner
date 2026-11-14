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

## Kata CI guest kernel

`kata-ci-kernel/` and **Build Kata CI guest kernel** build the guest kernel
that the eunomia-bpf CI runners boot in their Kata Containers VMs: Kata
`4.3.1`'s debug kernel (Linux `6.18.56` with tracefs, uprobe and kprobe events,
BTF and the BPF JIT) plus `kata-ci-kernel/ci.conf`, which adds what CI needs and
Kata's kernels leave out (`CONFIG_CROSS_MEMORY_ATTACH` for
`process_vm_readv`, `CONFIG_CHECKPOINT_RESTORE`, and
`CONFIG_TRACEFS_AUTOMOUNT_DEPRECATED` for tools that read
`/sys/kernel/debug/tracing`). The workflow publishes
`ghcr.io/yunwei37/kata-ci-kernel` with `/kernel/vmlinux` and `/kernel/config`
and records the digest in the run summary.
