apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: podinfo
  namespace: tenant1-production
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: tenant1-production
  project: tenant1
  sources:
    - repoURL: ghcr.io/stefanprodan/charts
      chart: podinfo
      targetRevision: 6.9.2
      helm:
        valuesObject:
          ui:
            message: Welcome to Tenant tenant1
            color: '#00426b'
            logo: https://platform.cloudogu.com/icon3.png
          ingress:
            enabled: true
            hosts:
              - host: podinfo.tenant1.localhost
                paths:
                  - path: /
                    pathType: ImplementationSpecific
  syncPolicy:
    automated:
      prune: true
      selfHeal: true