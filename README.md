# gop-multi-tenant-shared-example

Deploy an IDP to be shared by multiple tenants.

See also 
* [slides of the talk "Repo structures" at CloudLand 2025](https://cloudogu.github.io/gitops-talks/2025-07-cloud-land/#).
* [slides of the talk "Managing tenants using GitOps" at CLC 2025](https://cloudogu.github.io/gitops-talks/2025-11-clc/#/).

## Running locally

### Simple start

Only deploy one static app ([PodInfo](https://github.com/stefanprodan/podinfo/)) per Tenant

```bash
GOP_VERSION=0.15.0
GOP_CHART_VERSION='0.4.0'

bash <(curl -s "https://raw.githubusercontent.com/cloudogu/gitops-playground/$GOP_VERSION/scripts/init-cluster.sh")

helm upgrade gop -i oci://ghcr.io/cloudogu/gop-helm --version $GOP_CHART_VERSION -n gop --kube-context k3d-gitops-playground --create-namespace --values - <<EOF
image:
  tag: ${VERSION}
config:
  application:
    baseUrl: http://localhost
  features:
    argocd:
      active: true
      values:
        argo-cd:
          configs:
            params:
              # Otherwise Argo CD will not be able to load tenant apps from their namespaces
              # TODO this is not set in GOP :/
              application.namespaces: "*"
    ingress:
      active: true
  content:
    repos:
      - url: 'https://github.com/cloudogu/gop-multi-tenant-shared-example'
        path: repos
        ref: main
        templating: true
        type: FOLDER_BASED
        overwriteMode: UPGRADE
    namespaces:
      - tenant1-production
      - tenant1-staging
      - tenant2
    variables:
      petclinic:
        baseDomain: "petclinic.localhost"
      nginx:
        baseDomain: "nginx.localhost"
      images:
        petclinic: "eclipse-temurin:17-jre-alpine"
EOF
```

After deployment is finished, you can access the tenant cluster via
* the Argo CD UI at http://argocd.localhost
* SCM-Manager (git server) UI at http://scmm.localhost

Credentials are `admin`/`admin`.

### More complex example
If you want to include Building your own app and deploying it there is a more complex example as well inlcuding Jenkins and a Regsitry.

```bash
VERSION='0.12.1'

bash <(curl -s "https://raw.githubusercontent.com/cloudogu/gitops-playground/$GOP_VERSION/scripts/init-cluster.sh")

helm upgrade gop -i oci://ghcr.io/cloudogu/gop-helm --version 0.4.0 -n gop --kube-context k3d-gitops-playground --create-namespace --values - <<EOF
image:
  tag: ${VERSION}
config:
$(sed 's/^/  /' gop-config.yaml)
EOF
```