{
    "apiVersion": "v1",
    "data": {
      "prometheus.yml" : importstr "configmap/prometheus.yml",
    },
    "kind": "ConfigMap",
    "metadata": {
        "name": "prometheus-configmap",
        "namespace": "monitoring"
    }
}
