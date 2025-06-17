#!/bin/bash

# delete and create kind cluster
kind delete cluster -n zarf
kind create cluster -n zarf
sleep 15
../zarf/build/zarf package deploy zarf-init-amd64-v0.56.0.tar.zst --confirm

# # rebuild the guac image
# cd ../guac
# make build_local_container

cd ../ossf-cd-2025
../zarf/build/zarf package create guac/
../zarf/build/zarf package deploy zarf-package-guac-amd64-0.6.2.tar.zst --confirm
