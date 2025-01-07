package main

import (
	"encoding/base64"
	"fmt"
	"os"

	"sigs.k8s.io/controller-runtime/pkg/envtest"
)

func main() {
	testEnv := &envtest.Environment{
		CRDDirectoryPaths: []string{
			"./crds/",
		},
	}

	cfg, err := testEnv.Start()
	if err != nil {
		panic(err)
	}
	fmt.Printf("%v", cfg.Host)

	f, err := os.OpenFile("/tmp/kubeconfig.envtest", os.O_CREATE|os.O_WRONLY|os.O_TRUNC, 0o644)
	if err != nil {
		panic(err)
	}

	ca := base64.StdEncoding.EncodeToString(cfg.CAData)
	cert := base64.StdEncoding.EncodeToString(cfg.CertData)
	key := base64.StdEncoding.EncodeToString(cfg.KeyData)

	_, err = fmt.Fprintf(f, template, ca, cfg.Host, cert, key)
	if err != nil {
		panic(err)
	}
}

const template = `apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: %s
    server: %s
  name: envtest
contexts:
- context:
    cluster: envtest
    user: admin
  name: envtest
current-context: envtest
kind: Config
preferences: {}
users:
- name: admin
  user:
    client-certificate-data: %s
    client-key-data: %s`
