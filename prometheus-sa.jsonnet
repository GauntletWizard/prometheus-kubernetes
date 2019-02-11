[
  // Service Account
  {
    apiVersion: "v1",
    kind: "ServiceAccount",
    metadata: {
      name: "prometheus",
    },
  },
  {
    apiVersion: "rbac.authorization.k8s.io/v1",
    kind: "ClusterRoleBinding",
    metadata: {
      name: "prometheus",
    },
    roleRef: {
      apiGroup: "rbac.authorization.k8s.io",
      kind: "ClusterRole",
      name: "cluster-prometheus",
    },
    subjects: [
      {
        kind: "ServiceAccount",
        name: "prometheus",
        namespace: "default",
      },
    ],
  },
  {
    apiVersion: "rbac.authorization.k8s.io/v1",
    kind: "ClusterRole",
    metadata: {
      name: "cluster-prometheus",
    },
    rules: [
      {
        apiGroups: [
          "",
        ],
        resources: [
          "nodes",
          "pods",
          "services",
          "endpoints",
          "ingress",
        ],
        verbs: [
          "get",
          "list",
          "watch",
        ],
      },
    ],
  },
]
