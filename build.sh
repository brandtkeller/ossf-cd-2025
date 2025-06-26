#!/bin/bash

cd /home/dev/work/

# build the guac image
git clone git@github.com:brandtkeller/guac.git
cd guac
git checkout openssf_zarf_integration
make build_local_container

# build the zarf cli
cd /home/dev/work
git clone git@github.com:zarf-dev/zarf.git
cd zarf
git checkout openssf_guac_integration
make build
sudo cp build/zarf /usr/local/bin/zarf

# build the guac package
cd /home/dev/work/ossf-cd-2025
helm repo add minio https://charts.min.io/
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm repo update
zarf package create guac/ -o packages -a arm64

zarf package create podinfo/ -o packages -a arm64

cd packages/
curl -LO https://github.com/zarf-dev/zarf/releases/download/v0.56.0/zarf-init-arm64-v0.56.0.tar.zst

cd /home/dev/work/ossf-cd-2025



