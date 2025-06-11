# OpenSSF Community Days 2025

The purpose of this repository is to serve as a central location for information about the OpenSSF Community Days 2025 submission: 

[Enhancing Supply Chain Security: Integrating Zarf and GUAC for Seamless SBOM Generation and Delivery](https://sched.co/1zhnb)

## Prerequisites

- Zarf needs to support delivering the SBOM to the registry during deploy
- GUAC needs to know how to read from the Zarf registry
  - `guaccollect registry` will read from a registry
    - How to specify target url?
    - How to add credentials?
- Attempt to use the visualizer to get feedback on package deployments and new sboms

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