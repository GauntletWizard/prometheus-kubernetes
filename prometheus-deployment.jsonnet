{
  apiVersion: "apps/v1beta1",
  kind: "StatefulSet",
  metadata: {
    name: "prometheus-deployment",
    namespace: "default",
  },
  spec: {
    replicas: 2,
    selector: {
      matchLabels: {
        app: "prometheus",
      },
    },
    serviceName: "prometheus",
    podManagementPolicy: "OrderedReady",
    updateStrategy: { type: "RollingUpdate" },
    template: {
      metadata: {
        labels: {
          app: "prometheus",
        },
        name: "prometheus",
      },
      spec: {
        containers: [
          {
            args: [
              "--config.file=/etc/prometheus/prometheus.yml",
              "--storage.tsdb.retention.size=10GB",
              "--web.external-url=$(EXTERNAL_URL)",
            ],
            env: [
              {
                name: "EXTERNAL_URL",
                valueFrom: {
                  configMapKeyRef: {
                    key: "external-url",
                    name: "prometheus-env",
                  },
                },
              },
              {
                name: "STORAGE_RETENTION",
                valueFrom: {
                  configMapKeyRef: {
                    key: "storage-retention",
                    name: "prometheus-env",
                  },
                },
              },
            ],
            image: "prom/prometheus",
            name: "prometheus",
            ports: [
              {
                containerPort: 9090,
                name: "web",
              },
            ],
            volumeMounts: [
              {
                mountPath: "/etc/prometheus",
                name: "config-volume",
              },
              {
                mountPath: "/etc/prometheus-rules",
                name: "rules-volume",
              },
              {
                mountPath: "/data",
                name: "prometheus-data",
              },
            ],
          },
        ],
        serviceAccountName: "prometheus",
        volumes: [
          {
            configMap: {
              name: "prometheus-configmap",
            },
            name: "config-volume",
          },
          {
            configMap: {
              name: "prometheus-rules",
            },
            name: "rules-volume",
          },
        ],
      },
    },
    volumeClaimTemplates: [
      {
        metadata: {
          name: "prometheus-data",
        },
        spec: {
          accessModes: [
            "ReadWriteOnce",
          ],
          resources: {
            requests: {
              storage: "2Gi",
            },
          },
        },
      },
    ],
  },
}
