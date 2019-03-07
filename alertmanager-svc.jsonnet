{
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "annotations": {
            "prometheus.io/path": "/alertmanager/metrics",
            "prometheus.io/scrape": "true"
        },
        "labels": {
            "name": "alertmanager"
        },
        "name": "alertmanager",
        "namespace": "monitoring"
    },
    "spec": {
        "ports": [
            {
                "name": "alertmanager",
                "port": 9093,
                "protocol": "TCP",
                "targetPort": 9093
            }
        ],
        "selector": {
            "app": "alertmanager"
        }
    }
}
