#!/bin/bash

set -x

tee > /tmp/metallb_system_namespace.yaml <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: metallb-system
EOF
kubectl apply -f /tmp/metallb_system_namespace.yaml

helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb -n metallb-system

sleep 20
helm osh wait-for-pods metallb-system

tee > /tmp/metallb_ipaddresspool.yaml <<EOF
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
    name: public
    namespace: metallb-system
spec:
    addresses:
    - "172.24.128.0/24"
EOF

kubectl apply -f /tmp/metallb_ipaddresspool.yaml

tee > /tmp/metallb_l2advertisement.yaml <<EOF
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
    name: public
    namespace: metallb-system
spec:
    ipAddressPools:
    - public
EOF

kubectl apply -f /tmp/metallb_l2advertisement.yaml
