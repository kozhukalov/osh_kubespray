#!/bin/bash

set -x

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm upgrade --install --create-namespace ingress-nginx ingress-nginx/ingress-nginx \
    --version="4.8.3" \
    --namespace=openstack \
    --set controller.kind=Deployment \
    --set controller.admissionWebhooks.enabled="false" \
    --set controller.scope.enabled="true" \
    --set controller.service.enabled="false" \
    --set controller.ingressClassResource.name=nginx \
    --set controller.ingressClassResource.controllerValue="k8s.io/ingress-nginx" \
    --set controller.ingressClassResource.default="false" \
    --set controller.ingressClass=nginx \
    --set controller.labels.app=ingress-api

helm osh wait-for-pods openstack

helm upgrade --install --create-namespace ingress-nginx-ceph ingress-nginx/ingress-nginx \
  --version="4.8.3" \
  --namespace=ceph \
  --set controller.kind=Deployment \
  --set controller.admissionWebhooks.enabled="false" \
  --set controller.scope.enabled="true" \
  --set controller.service.enabled="false" \
  --set controller.ingressClassResource.name=nginx-ceph \
  --set controller.ingressClassResource.controllerValue="k8s.io/ingress-nginx-ceph" \
  --set controller.ingressClass=nginx-ceph \
  --set controller.labels.app=ingress-api

helm osh wait-for-pods ceph
