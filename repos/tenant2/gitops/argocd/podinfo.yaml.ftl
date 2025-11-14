apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: podinfo
  namespace: tenant2
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: tenant2
  project: tenant2
  sources:
    - repoURL: ghcr.io/stefanprodan/charts
      chart: podinfo
      targetRevision: 6.9.2
      helm:
        valuesObject:
          ui:
            message: Welcome to Tenant tenant2
            color: '#000000'
            logo: https://platform.cloudogu.com/icon3.png
          ingress:
            enabled: true
            hosts:
              - host: podinfo.tenant2.localhost
                paths:
                  - path: /
                    pathType: ImplementationSpecific
  syncPolicy:
    automated:
      prune: true
      selfHeal: true