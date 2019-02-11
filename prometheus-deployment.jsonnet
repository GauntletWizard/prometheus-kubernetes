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
              "-storage.local.retention=$(STORAGE_RETENTION)",
              "-config.file=/etc/prometheus/prometheus.yml",
              "-alertmanager.url=http://alertmanager:9093/alertmanager",
              "-web.external-url=$(EXTERNAL_URL)",
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
            image: "quay.io/coreos/prometheus:latest",
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
                mountPath: "/prometheus",
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
