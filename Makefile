.PHONY: download.crds
download.crds:
	kustomize build github.com/kong/kubernetes-configuration/config/crd/ingress-controller?rev=1.0.3 > crds/crds.yaml

ifndef KIC_BINARY
$(error KIC_BINARY is not set)
endif

.PHONY: run
run: download.crds
	KIC_BINARY=$(KIC_BINARY) ./run.sh
