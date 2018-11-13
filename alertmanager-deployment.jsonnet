{
    "apiVersion": "extensions/v1beta1",
    "kind": "Deployment",
    "metadata": {
        "name": "alertmanager",
        "namespace": "default"
    },
    "spec": {
        "replicas": 1,
        "selector": {
            "matchLabels": {
                "app": "alertmanager"
            }
        },
        "template": {
            "metadata": {
                "labels": {
                    "app": "alertmanager"
                },
                "name": "alertmanager"
            },
            "spec": {
                "containers": [
                    {
                        "args": [
                            "-config.file=/etc/alertmanager/config.yml",
                            "-storage.path=/alertmanager",
                            "-web.external-url=$(EXTERNAL_URL)/alertmanager"
                        ],
                        "env": [
                            {
                                "name": "EXTERNAL_URL",
                                "valueFrom": {
                                    "configMapKeyRef": {
                                        "key": "url",
                                        "name": "external-url"
                                    }
                                }
                            }
                        ],
                        "image": "prom/alertmanager:latest",
                        "name": "alertmanager",
                        "ports": [
                            {
                                "containerPort": 9093,
                                "name": "alertmanager"
                            }
                        ],
                        "volumeMounts": [
                            {
                                "mountPath": "/etc/alertmanager",
                                "name": "config-volume"
                            },
                            {
                                "mountPath": "/etc/alertmanager-templates",
                                "name": "templates-volume"
                            },
                            {
                                "mountPath": "/alertmanager",
                                "name": "alertmanager"
                            }
                        ]
                    }
                ],
                "volumes": [
                    {
                        "configMap": {
                            "name": "alertmanager"
                        },
                        "name": "config-volume"
                    },
                    {
                        "configMap": {
                            "name": "alertmanager-templates"
                        },
                        "name": "templates-volume"
                    },
                    {
                        "emptyDir": {},
                        "name": "alertmanager"
                    }
                ]
            }
        }
    }
}
