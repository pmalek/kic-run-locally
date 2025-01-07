#!/bin/bash

if [[ -z "${KIC_BINARY}" ]]; then
    echo "KIC_BINARY is not set"
    exit 1
fi

CONTAINER_NAME=kong
docker run -d --rm --name ${CONTAINER_NAME} \
    -e "KONG_DATABASE=off" \
    -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
    -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
    -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
    kong/kong-gateway:3.9.0.0

KUBE_HOST=$(KUBEBUILDER_ASSETS=$(setup-envtest use -p path) go run .)
trap "docker stop ${CONTAINER_NAME} ; docker rm ${CONTAINER_NAME} ; killall etcd ; killall kube-apiserver" EXIT SIGINT

POD_NAME=local \
POD_NAMESPACE=default \
  ${KIC_BINARY} \
    --kubeconfig /tmp/kubeconfig.envtest \
    --anonymous-reports=false \
    --kong-admin-url "http://localhost:8001" \
    --publish-service kong-system/ingress-controller-kong-proxy

