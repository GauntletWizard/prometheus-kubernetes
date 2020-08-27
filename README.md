# Prometheus for Kubernetes, out of the box.

## Prerequisites

### Kubectl

`kubectl` should be configured, and a basic knowledge of Kubernetes concepts and where to find documentation is assumed.

## Namespace

This example uses `monitoring` namespace. If you wish to use your own namespace, just export `NAMESPACE=mynamespace` environment variable.

## Components
### Prometheus StatefulSet
The Prometheus StatefulSet creates the Prometheus pods. A Statefulset is used for automatic creation of storage volumes. A service and 

Connections:
Configuration values are loaded from three configmaps. One is the prometheus config map - This defines how prometheus handles service discovery and finds pods. Another is the rules volume; This contains recording rules and alerts. Finally, a prometheus-env configmap defines some top-level parameters about how Prometheus launches
Backends:
Prometheus' only backend is a storage volume. On AWS/GKE/DO, this SHOULD be an automaticallly provisioned volumes. Sizing of this storage volume should take into account not only the storage horizon, but also the number of iops provided by the storage size (iops is implicitly tied to volume size on most cloud providers). THis should be overprovisioned because it's hard to change later.
Frontend:
Prometheus' HA story is replica based. Always run two or more prometheus instances in producton clusters. Load balancing across them will result in slightly different results depending on which pod handles the request. This is normal. If the results are wildly different, something is wrong.

## Alerting

## Included alert rules

Prometheus alert rules which are already included in this repo:

## Notifications

##  Updating configuration
