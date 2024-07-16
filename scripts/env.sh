#!/bin/bash

export OPENSTACK_RELEASE=2024.1
export FEATURES="${OPENSTACK_RELEASE} ubuntu_jammy"
export OVERRIDES_DIR=$(pwd)/overrides
export CEPH_OSD_DATA_DEVICE="/dev/vdb"
