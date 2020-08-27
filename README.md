# Prometheus for Kubernetes
This repo defines a Kustomization folder for a basic working Prometheus, Grafana, and etc installation. It can be deployed as-is, but should be understood before applied to production. 

## Prerequisites

### Kubectl

`kubectl` should be configured, and a basic knowledge of Kubernetes concepts and where to find documentation is assumed.

### Namespace

This example uses `monitoring` namespace. If you wish to use your own namespace, override it with Kustomize.

## Components
### Prometheus
Prometheus is the core component of this infrastructures.

#### Configuration:
Configuration values are loaded from three configmaps. One is the prometheus config map - This defines how prometheus handles service discovery and finds pods. Another is the rules volume; This contains recording rules and alerts. Finally, a prometheus-env configmap defines some top-level parameters about how Prometheus launches
#### Backends:
Prometheus' only backend is a storage volume. On AWS/GKE/DO, this SHOULD be an automaticallly provisioned volumes. Sizing of this storage volume should take into account not only the storage horizon, but also the number of iops provided by the storage size (iops is implicitly tied to volume size on most cloud providers). This should be overprovisioned because it's hard to change later.
#### Frontend:
Prometheus provides a WebUI and HTTP-based UI, accessible via a service or ingress. Prometheus' HA story is replica based. Always run two or more prometheus instances in producton clusters. Load balancing across them will result in slightly different results depending on which pod handles the request. This is normal. If the results are wildly different, something is wrong.

### Alertmanager
The [Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/) handles alerts sent by client applications such as the Prometheus server. It takes care of deduplicating, grouping, and routing them to the correct receiver integration such as email, PagerDuty, or OpsGenie. It also takes care of silencing and inhibition of alerts.

#### Configuration:
Alertmanager is configured via it's own configmap, `alertmanager-config`. No default routing chain is provided, and operators are required to set one up before continuing. The included configuration uses only emptyDir volumes
#### Backends:
Alertmanager relies upon your alerting infrastructure; This may be Pagerduty, OpsGenie, or simply e-mail. As shipped, Alertmanager uses an EmptyDir for storing silences, but can be configured with a storage volume
#### Frontend: 
Alertmanager provides a WebUI for managing alerts.

### Grafana
[Grafana](https://grafana.com/) is a multi-platform open source analytics and interactive visualization web application. It provides charts, graphs, and alerts for the web when connected to supported data sources. Grafana is the sugar that makes the rest of this infrastructure palatable.

#### Configuration:
Grafana has extensive configuration via WebUI and via Environment Variables. It is recommended to review it independently.
The included configuration uses a single Grafana instance backed by a SQlite
#### Backends:
Grafana relies upon the Prometheus instances for high availability. The included configuration also uses a provisioned volume to store a configuration database
#### Frontends:
Grafana provides a WebUI, and can be the only part of this infrastructure exposed if you so wish

### Node-exporter
The Prometheus [Node Exporter](https://prometheus.io/docs/guides/node-exporter/) exposes a wide variety of hardware- and kernel-related metrics.

#### Configuration:
Node Exporter does not require configuration via file. Individual exporters can be enabled or disabled via command line flag. 
#### Backends:
Node Exporter does not rely on any external services.
#### Frontend:
Node Exporter provides a HTTP Interface that Prometheus scrapes. It does not store any information; You can observe it directly to see available metrics and read help text, but you should 

### TOOD: kube-state-metrics


## Configuring and Using Prometheus

### Scraping your pods/targets

### Recording and Alerting

### Notifications

### Included alert rules

Prometheus alert rules which are already included in this repo:

- TODO: Prometheus (storage utilization, recording rule time)
- TODO: Nodes Unavailable, Node conditions
