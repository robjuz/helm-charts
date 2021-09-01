# Futtertrog

[Futtertrog](https://github.com/robjuz/futtertrog) Is an easy system to organize yours and your coworkers lunch orders.

## TL;DR

```console
helm repo add robjuz https://robjuz.github.io/helm-charts/
helm install futtertrog robjuz/futtertrog
```

## Introduction

This chart bootstraps a [futtertrog](https://github.com/robjuz/futtertrog) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Futtertrog application.

This chart has been tested to work with NGINX Ingress and cert-manager on top of the [MicroK8s](https://microk8s.io/).

## Prerequisites

- Kubernetes 1.18+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `futtertrog`:

```console
helm install futtertrog robjuz/futtertrog
```

The command deploys Futtertrog on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `futtertrog` deployment:

```console
helm delete futtertrog
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Common parameters

| Name                | Description                                        | Value  |
| ------------------- | -------------------------------------------------- | ------ |
| `nameOverride`      | String to partially override common.names.fullname | `nil`  |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil`  |

### Futtertrog image parameters

| Name                | Description                                            | Value                 |
| ------------------- | ------------------------------------------------------ | --------------------- |
| `image.repository`  | Futtertrog image repository                            | `robjuz/futtertrog`   |
| `image.tag`         | Futtertrog image tag (immutable tags are recommended)  | `latest`              |
| `image.pullPolicy`  | Futtertrog image pull policy                           | `IfNotPresent`        |
| `imagePullSecrets`  | Futtertrog image pull secrets                          | `[]`                  |

### Futtertrog configuration parameters

| Name            | Description                      | Value                     |
| ----------------| ---------------------------------| ------------------------- |
| `appKey`        | Application key                  | ``                        |
| `adminNamel`    | Name of the admin                | `admin@futtertrog.local`  |
| `adminEmail`    | Email for the admin account      | `admin@futtertrog.local`  |
| `adminPassword` | Password for the admin account   | `changemeplease`          |

### Futtertrog services configuration parameters

| Name                  | Description                      | Value   |
| --------------------- | ---------------------------------| ------- |
| `gitlab.enabled`      | Enable login with Gitlab         | `false` |
| `gitlab.url`          | Gitlab url                       | ``      |
| `gitlab.clientId`     | Gitlab application clientId      | ``      |
| `gitlab.clientSecret` | Gitlab application clientSecret  | ``      |
| `nexmo.key`           | Nexmo key                        | ``      |
| `nexmo.secret`        | Nexmo secret                     | ``      |

### Futtertrog meal providers configuration parameters

| Name                      | Description                                | Value                  |
| ------------------------- | ------------------------------------------ | ---------------------- |
| `holzke.enabled`          | Enable Holzke provider                     | `false`                |
| `holzke.login`            | Holzke login                               | ``                     |
| `holzke.password`         | Holzke password                            | ``                     |
| `holzke.cronjob`          | Enable Holzke automatic meal import        | `false`                |
| `holzke.orderInfo`        | Additional information when placing order  | ``                     |
| `call_a_pizza.enabled`    | Enable Call A Pizza provider               | `dresden_loebtau_sued` |
| `call_a_pizza.location`   | Call A Pizza location                      | ``      |

[comment]: <> (| `call_a_pizza.categories` | Call A Pizza categories to import     | ``      |)


### Futtertrog deployment parameters

| Name                                    | Description                                                | Value           |
| --------------------------------------- | -----------------------------------------------------------| --------------- |
| `replicaCount`                          | Number of Futtertrog replicas to deploy                         | `1`             |
| `updateStrategy.type`                   | Futtertrog deployment strategy type                             | `RollingUpdate` |
| `updateStrategy.rollingUpdate`          | Futtertrog deployment rolling update configuration parameters   | `{}`            |
| `podAnnotations`                        | Annotations for Futtertrog pods                                 | `{}`            |

### Traffic exposure parameters

| Name                               | Description                                                                      | Value          |
| ---------------------------------- | ---------------------------------------------------------------------------------| -------------- |
| `service.type`                     | Futtertrog service type                                                               | `ClusterIP`    |
| `service.port`                     | Futtertrog service HTTP port                                                          | `80`           |
| `ingress.enabled`                  | Enable ingress record generation for Futtertrog                                       | `false`        |
| `ingress.certManager`              | Add the corresponding annotations for cert-manager integration                   | `false`        |
| `ingress.hostname`                 | Default host for the ingress record                                              | `kimai.local`  |
| `ingress.annotations`              | Additional custom annotations for the ingress record                             | `{}`           |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter    | `false`        |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                               | `[]`           |

### Database parameters

| Name                                       | Description                                                               | Value             |
| ------------------------------------------ | ------------------------------------------------------------------------- | ----------------- |
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

The above parameters map to the env variables defined in [robjuz/futtertrog](https://github.com/robjuz/futtertrog). For more information please refer to the [robjuz/futtertrog](https://github.com/robjuz/futtertrog) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set adminEmail=admin@example.com \
  --set adminPassword=password \
  --set mariadb.auth.rootPassword=secretpassword \
    robjuz/futtertrog
```

The above command sets the Futtertrog administrator account username and password to `admin@example.com` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install futtertrog -f values.yaml robjuz/futtertrog
```

## Configuration and installation details

### External database support

You may want to have Futtertrog connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#database-parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. Here is an example:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve Futtertrog.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management.
