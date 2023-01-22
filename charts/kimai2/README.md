# Kimai

[Kimai](https://kimai.org/)  is a free & open source timetracker. It tracks work time and prints out a summary of your activities on demand. Yearly, monthly, daily, by customer, by project … Its simplicity is its strength.

## TL;DR

```console
helm repo add robjuz https://robjuz.github.io/helm-charts/
helm install kimai robjuz/kimai2
```

## Introduction

This chart bootstraps a [Kimai2](https://github.com/tobybatch/kimai2) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Kimai application.

This chart has been tested to work with NGINX Ingress and cert-manager on top of the [MicroK8s](https://microk8s.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `kimai`:

```console
helm install kimai robjuz/kimai2
```

The command deploys Kimai on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `kimai` deployment:

```console
helm delete kimai
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Common parameters

| Name               | Description                                        | Value |
|--------------------|----------------------------------------------------|-------|
| `nameOverride`     | String to partially override common.names.fullname | `nil` |
| `fullnameOverride` | String to fully override common.names.fullname     | `nil` |

### Kimai Image parameters

| Name               | Description                                      | Value          |
|--------------------|--------------------------------------------------|----------------|
| `image.repository` | Kimai image repository                           | `kimai/kimai2` |
| `image.tag`        | Kimai image tag (immutable tags are recommended) | `apache`       |
| `image.pullPolicy` | Kimai image pull policy                          | `IfNotPresent` |
| `imagePullSecrets` | Kimai image pull secrets                         | `[]`           |

### Kimai Configuration parameters

| Name                 | Description                                        | Value                             |
|----------------------|----------------------------------------------------|-----------------------------------|
| `existingSecret`     | Use existing secret for password details           | `""`                              |
| `kimaiAppSecret`     | Secret used to encrypt session cookies             | `change_this_to_something_unique` |
| `kimaiAdminEmail`    | Email for the superadmin account                   | `admin@kimai.local`               |
| `kimaiAdminPassword` | Password for the superadmin account                | `changemeplease`                  |
| `kimaiEnvironment`   | Kimai environment name                             | `prod`                            |
| `kimaiMailerUrl`     | SMTP connection for emails                         | `null://localhost`                |
| `kimaiMailerFrom`    | Application specific “from” address for all emails | `kimai@example.com`               |

### PHP Configuration parameters

| Name               | Description                                          | Value |
|--------------------|------------------------------------------------------|-------|
| `php.memory_limit` | The max. amount of memory a script may consume in MB | `128` |

### Kimai deployment parameters

| Name                                 | Description                                              | Value           |
|--------------------------------------|----------------------------------------------------------|-----------------|
| `replicaCount`                       | Number of Kimai replicas to deploy                       | `1`             |
| `updateStrategy.type`                | Kimai deployment strategy type                           | `RollingUpdate` |
| `updateStrategy.rollingUpdate`       | Kimai deployment rolling update configuration parameters | `{}`            |
| `schedulerName`                      | Alternate scheduler                                      | `nil`           |
| `serviceAccountName`                 | ServiceAccount name                                      | `default`       |
| `hostAliases`                        | Kimai pod host aliases                                   | `[]`            |
| `podAnnotations`                     | Annotations for Kimai pods                               | `{}`            |
| `livenessProbe.enabled`              | Enable livenessProbe on Kimai containers                 | `true`          |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                  | `120`           |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                         | `10`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                        | `5`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                      | `6`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                      | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe on Kimai containers                | `true`          |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                 | `30`            |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                        | `10`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                       | `5`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                     | `6`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                     | `1`             |
| `startupProbe.enabled`               | Enable startupProbe on Kimai containers                  | `false`         |
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
| `service.type`        | Kimai service type                                                            | `ClusterIP`   |
| `service.port`        | Kimai service HTTP port                                                       | `80`          |
| `ingress.enabled`     | Enable ingress record generation for Kimai                                    | `false`       |
| `ingress.certManager` | Add the corresponding annotations for cert-manager integration                | `false`       |
| `ingress.hostname`    | Default host for the ingress record                                           | `kimai.local` |
| `ingress.annotations` | Additional custom annotations for the ingress record                          | `{}`          |
| `ingress.tls`         | Enable TLS configuration for the host defined at `ingress.hostname` parameter | `false`       |
| `ingress.secrets`     | Custom TLS certificates as secrets                                            | `[]`          |

### Persistence Parameters

| Name                        | Description                                        | Value             |
|-----------------------------|----------------------------------------------------|-------------------|
| `persistence.enabled`       | Enable persistence using Persistent Volume Claims  | `true`            |
| `persistence.storageClass`  | Persistent Volume storage class                    | `nil`             |
| `persistence.accessModes`   | Persistent Volume access modes                     | `[ReadWriteOnce]` |
| `persistence.size`          | Persistent Volume size                             | `4Gi`             |
| `persistence.existingClaim` | The name of an existing PVC to use for persistence | `nil`             |

### Database Parameters

| Name                                       | Description                                                               | Value             |
|--------------------------------------------|---------------------------------------------------------------------------|-------------------|
| `mariadb.enabled`                          | Deploy a MariaDB server to satisfy the applications database requirements | `true`            |
| `mariadb.architecture`                     | MariaDB architecture. Allowed values: `standalone` or `replication`       | `standalone`      |
| `mariadb.auth.rootPassword`                | MariaDB root password                                                     | `changeme`        |
| `mariadb.auth.database`                    | MariaDB custom database                                                   | `kimai`           |
| `mariadb.auth.username`                    | MariaDB custom user name                                                  | `kimai`           |
| `mariadb.auth.password`                    | MariaDB custom user password                                              | `kimai`           |
| `mariadb.primary.persistence.enabled`      | Enable persistence on MariaDB using PVC(s)                                | `true`            |
| `mariadb.primary.persistence.storageClass` | Persistent Volume storage class                                           | `nil`             |
| `mariadb.primary.persistence.accessModes`  | Persistent Volume access modes                                            | `[ReadWriteOnce]` |
| `mariadb.primary.persistence.size`         | Persistent Volume size                                                    | `4Gi`             |

The above parameters map to the env variables defined in [tobybatch/kimai2](https://github.com/tobybatch/kimai2). For more information please refer to the [tobybatch/kimai2](https://github.com/tobybatch/kimai2) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set KimaiUsername=admin \
  --set KimaiPassword=password \
  --set mariadb.auth.rootPassword=secretpassword \
    robjuz/kimai2
```

The above command sets the Kimai administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install kimai -f values.yaml robjuz/kimai2
```

## Configuration and installation details

### External database support

You may want to have Kimai connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#database-parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. Here is an example:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve Kimai.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management.


## Upgrading

### To 2.0.0

This major release bumps default MariaDB branch to 10.6. Follow the [official instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-105-to-mariadb-106/) from upgrading between 10.5 and 10.6.

No major issues are expected during the upgrade.
