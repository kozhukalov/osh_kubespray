#!/bin/bash

set -x

tee > /tmp/openstack_endpoint_service.yaml <<EOF
---
kind: Service
apiVersion: v1
metadata:
  name: public-openstack
  namespace: openstack
  annotations:
    metallb.universe.tf/loadBalancerIPs: "172.24.128.100"
spec:
  externalTrafficPolicy: Cluster
  type: LoadBalancer
  selector:
    app: ingress-api
  ports:
    - name: http
      port: 80
    - name: https
      port: 443
EOF

kubectl apply -f /tmp/openstack_endpoint_service.yaml

apt install -y docker.io

docker run -d --name dnsmasq --restart always \
    --cap-add=NET_ADMIN \
    --network=host \
    --entrypoint dnsmasq \
    docker.io/openstackhelm/neutron:2024.1-ubuntu_jammy \
    --keep-in-foreground \
    --no-hosts \
    --bind-interfaces \
    --address="/openstack.svc.cluster.local/172.24.128.100" \
    --listen-address="172.17.0.1" \
    --no-resolv \
    --server=8.8.8.8

echo "nameserver 172.17.0.1" > /etc/resolv.conf
