#!/bin/bash

kind create cluster -n demo

sleep 15

zarf package deploy packages/zarf-init-arm64-v0.56.0.tar.zst --confirm

sleep 5

zarf package deploy packages/zarf-package-guac-arm64-0.6.2.tar.zst --confirm
