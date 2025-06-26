# OpenSSF Community Days 2025

The purpose of this repository is to serve as a central location for information about the OpenSSF Community Days 2025 submission: 

[Enhancing Supply Chain Security: Integrating Zarf and GUAC for Seamless SBOM Generation and Delivery](https://sched.co/1zhnb)

## General Information

This repository serves as an example of Conference-driven Development. This integration required changes to Zarf and GUAC - of which this exploration is intended to be used to drive changes back upstream upon completion.

## State
- [guac](git@github.com:brandtkeller/guac.git) - `openssf_zarf_integration`
- [zarf](git@github.com:zarf-dev/zarf.git) - `openssf_guac_integration`

[init package](https://github.com/zarf-dev/zarf/releases/download/v0.56.0/zarf-init-arm64-v0.56.0.tar.zst)

## Workflow

- Zarf will perform package creation through the standard process
- On package deploy - we will deploy the associated sboms in the package to the registry
- An airgap-ready and deployed instance of GUAC will be monitoring the Zarf internal docker registry and consuming SBOMs using the OCI collector.

## Prerequisites

This serves as live notes from throughout the investigation process. There are a variety of things to consider when building this integration and constraints to discover along the way. 

- Zarf needs to support delivering the SBOM to the registry during deploy
- GUAC needs to know how to read from the Zarf registry
  - `guaccollect registry` will read from a registry
    - How to specify target url?
      - `guaccollect registry <url>`
    - How to add credentials?
      - We have a private-registry secret all ready in the namespace
      - Can we mount this to the oci-collector?
- Attempt to use the visualizer to get feedback on package deployments and new sboms
  - Add a `connect` service
- Validate assumptions with cosign
  - Convert an existing sbom to a non-syft format
    - `zarf tools sbom convert ghcr.io_guacsec_guac_v0.14.0.json -o spdx-json=sbom.spdx.json`
  - port-forward to the registry
  - Login to the registry
  - Push to registry
    - `export COSIGN_EXPERIMENTAL=1`
    - `cosign attach sbom --sbom guac-sbom.spdx.json --type spdx --registry-referrers-mode oci-1-1 127.0.0.1:39603/guacsec/guac:v0.0.0-local-organic-guac-amd64`
    - `cosign attach sbom --sbom guac-sbom.spdx.json --type spdx --registry-referrers-mode legacy 127.0.0.1:39603/guacsec/guac:v0.0.0-local-organic-guac-amd64`
  - registry credentials are not available in the `private registry` secret for the zarf internal dns name
    - Could we add this with the same secret?

## Constraints
- The zarf registry - Distribution/Distribution@3.0.0 does not support the referral API
- Trouble using local chart and building chart dependencies
- Pods are restarting on initial release
  - Can we split the components up so that pods roll-out in the correct order?
    - Split out minio/nats - still see some initial restarts 

## Modifications
- Add a new service for the visualizer in order to add connect label
  - Make labels in chart more configurable per-service


## Other Notes
- [chainguard oci v1.1 blog](https://www.chainguard.dev/unchained/building-towards-oci-v1-1-support-in-cosign)
  - Look at using cosign to validate the sbom delivery

## Resolve Later
- Currently have to manually add the nats/minio helm chart repos using the helm CLI before running `zarf package create`
- guaccollect does not permit an IP:PORT target - hostname looks to be required
- validate if we need the depdev collector or osv certifier
  - turned off for now

# Presentation

- Demonstrate the laptop is offline
- Create a kind cluster & zarf init
- Deploy the guac package
- Review the guac visualizer
- Deploy the podinfo package
- Review the guac visualizer
