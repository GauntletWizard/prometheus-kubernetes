{
    "apiVersion": "extensions/v1beta1",
    "kind": "DaemonSet",
    "metadata": {
        "name": "node-exporter",
        "namespace": "monitoring"
    },
    "spec": {
        "template": {
            "metadata": {
                "labels": {
                    "app": "node-exporter"
                },
                "name": "node-exporter"
            },
            "spec": {
                "containers": [
                    {
                        "image": "prom/node-exporter",
                        "name": "node-exporter",
                        "ports": [
                            {
                                "containerPort": 9100,
                                "hostPort": 9100,
                                "name": "scrape"
                            }
                        ],
                        "volumeMounts": [
                            {
                                "mountPath": "/data-disk",
                                "name": "data-disk",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/root-disk",
                                "name": "root-disk",
                                "readOnly": true
                            }
                        ]
                    }
                ],
                "hostNetwork": true,
                "hostPID": true,
                "volumes": [
                    {
                        "emptyDir": {},
                        "name": "data-disk"
                    },
                    {
                        "hostPath": {
                            "path": "/"
                        },
                        "name": "root-disk"
                    }
                ]
            }
        }
    }
}
