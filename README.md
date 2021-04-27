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
Grafana relies upon the Prometheus instances for storage, and their availability is the primary factor. The included configuration also uses a provisioned volume to store a configuration database. For higher availability, you can switch it's storage backend to use Postgres, and run Grafana as a deployment instead. (https://grafana.com/docs/grafana/latest/administration/configuration/#database).
#### Frontends:
Grafana provides a WebUI, and can be the only part of this infrastructure exposed if you so wish. Grafana's Explore interface has advantages over the native Prometheus graph interface, and dashboards are the interface you should be using for day-to-day metrics and primary investigation of alerts
#### Operations:
Make sure you backup your Grafana dashboards on a regular basis. There are two approaches to this: One is to use the Grafana API to make static file copies of each dashboard, and the other is to backup the whole database of Grafana. Initially or on small applications the former might be simpler, but once Postgres is a required component of Grafana backups will likely be integrated.

### Node-exporter
The Prometheus [Node Exporter](https://prometheus.io/docs/guides/node-exporter/) exposes a wide variety of hardware- and kernel-related metrics.

#### Configuration:
Node Exporter does not require configuration via file. Individual exporters can be enabled or disabled via command line flag. 
#### Backends:
Node Exporter does not rely on any external services.
#### Frontend:
Node Exporter provides a HTTP Interface that Prometheus scrapes. It does not store any information; You can observe it directly to see available metrics and read help text, but persistence and history is stored in prometheus. 

### TODO: kube-state-metrics

## Configuring and Using Prometheus

### Scraping your pods/targets
You should familiarize yourself with Prometheus' [scrape config](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config) configuration. This version comes equipped with some basic scrape configurations, which should be sufficient to get you started.

You can inform the Prometheus Service Discovery of pods you want to scrape in one of two ways: Either having them belong to a service which is scraped by Prometheus, or by annotating them individually. With the former, simply set up your service as your would for serving traffic with it, and add the `prometheus.io/scrape` annotation to it:
```
apiVersion: v1
kind: Service
metadata:
  namespace: default
  name: hello-node
  annotations:
    prometheus.io/scrape: true
```

Alternatively, you can set the annotation directly on the pods themselves:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: default
  name: hello-node
spec:
  template:
    metadata:
      labels:
        app: hello-node
      annotations: 
        prometheus.io/scrape: true
```

#### Advanced Usage
For your most important or sensitive jobs, it may make sense to alter the prometheus.yml to directly include them as a job. This allows you to configure alternative ports for metrics monitoring, or bearer-tokens, passwords, or MTLS certificates used to authenticate to the pods to grab metrics. 

### Recording and Alerting

### Notifications

### Included alert rules

Prometheus alert rules which are already included in this repo:

- TODO: Prometheus (storage utilization, recording rule time)
- TODO: Nodes Unavailable, Node conditions
