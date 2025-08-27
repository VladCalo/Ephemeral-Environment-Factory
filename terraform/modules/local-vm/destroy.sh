#!/bin/bash

CLUSTER_PREFIX="ephemeral-cluster"

echo "Deleting Multipass VMs with prefix: $CLUSTER_PREFIX"
multipass delete --purge $(multipass list | grep $CLUSTER_PREFIX | awk '{print $1}')
multipass purge

echo "Cleaning up Terraform state..."

echo "Done."
