#!/bin/bash

set -x

if ! which helm 2>/dev/null 1>&2; then
    TMP_DIR=$(mktemp -d)
    curl -sSL https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz | tar -zxv --strip-components=1 -C ${TMP_DIR}
    mv "${TMP_DIR}"/helm /usr/local/bin/helm
    rm -rf "${TMP_DIR}"
fi

helm repo add openstack-helm https://tarballs.opendev.org/openstack/openstack-helm
helm repo add openstack-helm-infra https://tarballs.opendev.org/openstack/openstack-helm-infra
helm plugin install https://opendev.org/openstack/openstack-helm-plugin.git
