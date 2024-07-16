#!/bin/bash

set -x

kubectl label --overwrite nodes --all openstack-control-plane=enabled
kubectl label --overwrite nodes --all openstack-compute-node=enabled
kubectl label --overwrite nodes --all openvswitch=enabled
kubectl label --overwrite nodes --all linuxbridge=enabled

kubectl label --overwrite nodes --all ceph-mon=enabled
kubectl label --overwrite nodes --all ceph-osd=enabled
kubectl label --overwrite nodes --all ceph-mds=enabled
kubectl label --overwrite nodes --all ceph-rgw=enabled
kubectl label --overwrite nodes --all ceph-mgr=enabled

# deploy l3 agent only on the k8s control plane node
kubectl label --overwrite nodes -l "node-role.kubernetes.io/control-plane" l3-agent=enabled

# untaint control-plane node
kubectl taint nodes -l 'node-role.kubernetes.io/control-plane' node-role.kubernetes.io/control-plane-
