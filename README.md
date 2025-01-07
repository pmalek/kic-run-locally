# Run KIC locally with `envtest`

## How to

1. Build KIC binary ( can be achieved by running `make build` in KIC's repository root directory)
1. Run `make run` with `KIC_BINARY` set to the path of the binary.

This will:

- use envtest to run `kube-apiserver` and `etcd`
- run `kong` in a docker container
- start KIC by using the binary built in step 1 with
  - the `--kubeconfig` flag set to the kubeconfig file prepared to point to envtest cluster
  - the `--kong-admin-url` flag set to the URL of the `kong` container's admin API
