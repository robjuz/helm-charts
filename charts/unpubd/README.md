# Unpubd

[Unpubd](https://github.com/onepub-dev/unpubd) is essentially an installer for the unpub package.

## TL;DR

```console
helm repo add robjuz https://robjuz.github.io/helm-charts/
helm install Unpubd robjuz/Unpubd
```

## Introduction

This chart bootstraps a [Unpubd](https://github.com/onepub-dev/unpubd) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MongoDB chart](https://github.com/bitnami/charts/tree/master/bitnami/mongodb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Unpubd application.

This chart has been tested to work with NGINX Ingress and cert-manager on top of the [k3s](https://k3s.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `unpubd`:

```console
helm install unpubd robjuz/Unpubd
```

The command deploys Unpubd on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `unpubd` deployment:

```console
helm delete unpubd
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Common parameters

| Name               | Description                                        | Value |
|--------------------|----------------------------------------------------|-------|
| `nameOverride`     | String to partially override common.names.fullname | `nil` |
| `fullnameOverride` | String to fully override common.names.fullname     | `nil` |

### Unpubd Image parameters

| Name               | Description                                      | Value           |
|--------------------|--------------------------------------------------|-----------------|
| `image.repository` | Unpubd image repository                           | `noojee/unpubd` |
| `image.tag`        | Unpubd image tag (immutable tags are recommended) | `0.0.5`         |
| `image.pullPolicy` | Unpubd image pull policy                          | `IfNotPresent`  |
| `imagePullSecrets` | Unpubd image pull secrets                         | `[]`            |

### Unpubd deployment parameters

| Name                                 | Description                                              | Value           |
|--------------------------------------|----------------------------------------------------------|-----------------|
| `replicaCount`                       | Number of Unpubd replicas to deploy                       | `1`             |
| `updateStrategy.type`                | Unpubd deployment strategy type                           | `RollingUpdate` |
| `updateStrategy.rollingUpdate`       | Unpubd deployment rolling update configuration parameters | `{}`            |
| `schedulerName`                      | Alternate scheduler                                      | `nil`           |
| `serviceAccountName`                 | ServiceAccount name                                      | `default`       |
| `hostAliases`                        | Unpubd pod host aliases                                   | `[]`            |
| `podAnnotations`                     | Annotations for Unpubd pods                               | `{}`            |
| `livenessProbe.enabled`              | Enable livenessProbe on Unpubd containers                 | `true`          |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                  | `120`           |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                         | `10`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                        | `5`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                      | `6`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                      | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe on Unpubd containers                | `true`          |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                 | `30`            |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                        | `10`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                       | `5`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                     | `6`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                     | `1`             |
| `startupProbe.enabled`               | Enable startupProbe on Unpubd containers                  | `false`         |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe                   | `30`            |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe                          | `10`            |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe                         | `5`             |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe                       | `6`             |
| `startupProbe.successThreshold`      | Success threshold for startupProbe                       | `1`             |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one      | `{}`            |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one     | `{}`            |

### Traffic Exposure Parameters

| Name                  | Description                                                                   | Value         |
|-----------------------|-------------------------------------------------------------------------------|---------------|
| `service.type`        | Unpubd service type                                                            | `ClusterIP`   |
| `service.port`        | Unpubd service HTTP port                                                       | `80`          |
| `ingress.enabled`     | Enable ingress record generation for Unpubd                                    | `false`       |
| `ingress.certManager` | Add the corresponding annotations for cert-manager integration                | `false`       |
| `ingress.hostname`    | Default host for the ingress record                                           | `Unpubd.local` |
| `ingress.annotations` | Additional custom annotations for the ingress record                          | `{}`          |
| `ingress.tls`         | Enable TLS configuration for the host defined at `ingress.hostname` parameter | `false`       |
| `ingress.secrets`     | Custom TLS certificates as secrets                                            | `[]`          |

### Database Parameters

| Name                                       | Description                                                               | Value             |
|--------------------------------------------|---------------------------------------------------------------------------|-------------------|
| `mariadb.enabled`                          | Deploy a MariaDB server to satisfy the applications database requirements | `true`            |
| `mariadb.architecture`                     | MariaDB architecture. Allowed values: `standalone` or `replication`       | `standalone`      |
| `mariadb.auth.rootPassword`                | MariaDB root password                                                     | `changeme`        |
| `mariadb.auth.database`                    | MariaDB custom database                                                   | `Unpubd`           |
| `mariadb.auth.username`                    | MariaDB custom user name                                                  | `Unpubd`           |
| `mariadb.auth.password`                    | MariaDB custom user password                                              | `Unpubd`           |
| `mariadb.primary.persistence.enabled`      | Enable persistence on MariaDB using PVC(s)                                | `true`            |
| `mariadb.primary.persistence.storageClass` | Persistent Volume storage class                                           | `nil`             |
| `mariadb.primary.persistence.accessModes`  | Persistent Volume access modes                                            | `[ReadWriteOnce]` |
| `mariadb.primary.persistence.size`         | Persistent Volume size                                                    | `4Gi`             |

The above parameters map to the env variables defined in [tobybatch/Unpubd](https://github.com/tobybatch/Unpubd). For more information please refer to the [tobybatch/Unpubd](https://github.com/tobybatch/Unpubd) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set UnpubdUsername=admin \
  --set UnpubdPassword=password \
  --set mariadb.auth.rootPassword=secretpassword \
    robjuz/Unpubd
```

The above command sets the Unpubd administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install Unpubd -f values.yaml robjuz/Unpubd
```

## Configuration and installation details

### External database support

You may want to have Unpubd connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#database-parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. Here is an example:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve Unpubd.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management.
