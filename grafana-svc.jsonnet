{
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "labels": {
            "app": "grafana",
            "component": "core"
        },
        "name": "grafana",
        "namespace": "default"
    },
    "spec": {
        "ports": [
            {
                "name": "grafana",
                "port": 3000,
                "protocol": "TCP",
                "targetPort": 3000
            }
        ],
        "selector": {
            "app": "grafana",
            "component": "core"
        }
    }
}
