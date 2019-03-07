{
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
        "name": "alertmanager",
        "namespace": "monitoring"
    },
    "data": {
        "config.yml": importstr "configmap/alertmanager.yaml"
    },
}
