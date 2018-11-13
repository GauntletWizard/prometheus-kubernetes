{
    "apiVersion": "apps/v1beta1",
    "kind": "StatefulSet",
    "metadata": {
        "name": "prometheus-deployment",
        "namespace": "default"
    },
    "spec": {
        "replicas": 2,
        "selector": {
            "matchLabels": {
                "app": "prometheus"
            }
        },
        "serviceName": "prometheus",
        "podManagementPolicy": "OrderedReady",
        "template": {
            "metadata": {
                "labels": {
                    "app": "prometheus"
                },
                "name": "prometheus"
            },
            "spec": {
                "containers": [
                    {
                        "args": [
                            "-storage.local.retention=$(STORAGE_RETENTION)",
                            "-storage.local.memory-chunks=$(STORAGE_MEMORY_CHUNKS)",
                            "-config.file=/etc/prometheus/prometheus.yml",
                            "-alertmanager.url=http://alertmanager:9093/alertmanager",
                            "-web.external-url=$(EXTERNAL_URL)"
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
                            },
                            {
                                "name": "STORAGE_RETENTION",
                                "valueFrom": {
                                    "configMapKeyRef": {
                                        "key": "storage-retention",
                                        "name": "prometheus-env"
                                    }
                                }
                            },
                            {
                                "name": "STORAGE_MEMORY_CHUNKS",
                                "valueFrom": {
                                    "configMapKeyRef": {
                                        "key": "storage-memory-chunks",
                                        "name": "prometheus-env"
                                    }
                                }
                            }
                        ],
                        "image": "quay.io/coreos/prometheus:latest",
                        "name": "prometheus",
                        "ports": [
                            {
                                "containerPort": 9090,
                                "name": "web"
                            }
                        ],
                        "volumeMounts": [
                            {
                                "mountPath": "/etc/prometheus",
                                "name": "config-volume"
                            },
                            {
                                "mountPath": "/etc/prometheus-rules",
                                "name": "rules-volume"
                            },
                            {
                                "mountPath": "/etc/etcd/ssl",
                                "name": "etcd-tls-client-certs",
                                "readOnly": true
                            },
                            {
                                "mountPath": "/prometheus",
                                "name": "prometheus-data"
                            }
                        ]
                    }
                ],
                "volumes": [
                    {
                        "configMap": {
                            "name": "prometheus-configmap"
                        },
                        "name": "config-volume"
                    },
                    {
                        "configMap": {
                            "name": "prometheus-rules"
                        },
                        "name": "rules-volume"
                    }
                ]
            }
        },
        "volumeClaimTemplates": [
            {
                "metadata": {
                    "name": "prometheus-data"
                },
                "spec": {
                    "accessModes": [
                        "ReadWriteOnce"
                    ],
                    "resources": {
                        "requests": {
                            "storage": "2000Gi"
                        }
                    }
                }
            }
        ]
    }
}
