{
    "apiVersion": "extensions/v1beta1",
    "kind": "Deployment",
    "metadata": {
        "labels": {
            "app": "grafana",
            "component": "core"
        },
        "name": "grafana",
        "namespace": "default"
    },
    "spec": {
        "replicas": 1,
        "template": {
            "metadata": {
                "labels": {
                    "app": "grafana",
                    "component": "core"
                }
            },
            "spec": {
                "containers": [
                    {
                        "env": [
                            {
                                "name": "GF_AUTH_BASIC_ENABLED",
                                "value": "false"
                            },
                            {
                                "name": "GF_AUTH_ANONYMOUS_ENABLED",
                                "value": "true"
                            },
                            {
                                "name": "GF_AUTH_ANONYMOUS_ORG_ROLE",
                                "value": "Admin"
                            }
                        ],
                        "image": "grafana/grafana:3.1.1",
                        "name": "grafana",
                        "resources": {
                            "limits": {
                                "cpu": "100m",
                                "memory": "100Mi"
                            },
                            "requests": {
                                "cpu": "100m",
                                "memory": "100Mi"
                            }
                        },
                        "volumeMounts": [
                            {
                                "mountPath": "/var",
                                "name": "grafana-persistent-storage"
                            }
                        ]
                    },
                    {
                        "args": [
                            "apk --update add curl ; until $(curl --silent --fail --show-error --output /dev/null http://localhost:3000/api/datasources); do\n  printf '.' ; sleep 1 ;\ndone ; for file in *-datasource.json ; do\n  if [ -e \"$file\" ] ; then\n    echo \"importing $file\" \u0026\u0026\n    curl --silent --fail --show-error \\\n      --request POST http://localhost:3000/api/datasources \\\n      --header \"Content-Type: application/json\" \\\n      --data-binary \"@$file\" ;\n    echo \"\" ;\n  fi\ndone ; for file in *-dashboard.json ; do\n  if [ -e \"$file\" ] ; then\n    # wrap exported Grafana dashboard into valid json\n    echo \"importing $file\" \u0026\u0026\n    (echo '{\"dashboard\":';cat \"$file\";echo ',\"inputs\":[{\"name\":\"DS_PROMETHEUS\",\"pluginId\":\"prometheus\",\"type\":\"datasource\",\"value\":\"prometheus\"}]}') | curl --silent --fail --show-error \\\n      --request POST http://localhost:3000/api/dashboards/import \\\n      --header \"Content-Type: application/json\" \\\n      --data-binary @-;\n    echo \"\" ;\n  fi\ndone ; while true; do\n  sleep 1m ;\ndone\n"
                        ],
                        "command": [
                            "/bin/sh",
                            "-c"
                        ],
                        "image": "docker",
                        "name": "grafana-import-dashboards",
                        "volumeMounts": [
                            {
                                "mountPath": "/opt/grafana-import-dashboards",
                                "name": "config-volume"
                            }
                        ],
                        "workingDir": "/opt/grafana-import-dashboards"
                    }
                ],
                "volumes": [
                    {
                        "configMap": {
                            "name": "grafana-import-dashboards"
                        },
                        "name": "config-volume"
                    },
                    {
                        "emptyDir": {},
                        "name": "grafana-persistent-storage"
                    }
                ]
            }
        }
    }
}
