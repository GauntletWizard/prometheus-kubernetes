{
    "apiVersion": "v1",
    "kind": "ConfigMap",
    "metadata": {
        "name": "alertmanager",
        "namespace": "default"
    },
    "data": {
        "config.yml": importstr "configmap/alertmanager.yaml"
    },
}
