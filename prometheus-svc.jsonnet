{
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "annotations": {
            "prometheus.io/scrape": "true"
        },
        "labels": {
            "kubernetes.io/name": "Prometheus",
            "name": "prometheus-svc"
        },
        "name": "prometheus-svc",
        "namespace": "default"
    },
    "spec": {
        "ports": [
            {
                "name": "prometheus",
                "port": 9090,
                "protocol": "TCP",
                "targetPort": 9090
            }
        ],
        "selector": {
            "app": "prometheus"
        }
    }
}
