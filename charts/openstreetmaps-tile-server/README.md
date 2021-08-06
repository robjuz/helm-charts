# openstreetmaps-tile-server

[openstreetmaps-tile-server](https://openstreetmaps-tile-server.org/)  is a free & open source timetracker. It tracks work time and prints out a summary of your activities on demand. Yearly, monthly, daily, by customer, by project … Its simplicity is its strength.

## TL;DR

```console
helm repo add robjuz https://robjuz.github.io/helm-charts/
helm install openstreetmaps-tile-server robjuz/openstreetmaps-tile-server
```

## Introduction

This chart bootstraps a [openstreetmaps-tile-server](https://github.com/tobybatch/openstreetmaps-tile-server2) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages a customized [Bitnami PostgreSQL chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) with build openstreetmaps-tile-server module which is required for bootstrapping a PostgreSQL deployment for the database requirements of the openstreetmaps-tile-server application.

This chart has been tested to work with NGINX Ingress and cert-manager on top of the [MicroK8s](https://microk8s.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling and persistence support

## Installing the Chart

The installation consist of 2 steps
1. Initialisation
2. App deployment

### Initialisation
Set```openstreetmaps-tile-serverInitialize.enabled: true```

During the initialization, all required data are downloaded and the database is build.
To improve the import speed you can set additional PostgreSQL params

```yaml
  openstreetmaps-tile-serverInitialize:
    enabled: true
  
  postgresql:
    postgresqlExtendedConf:
      {
        "fsync": "off",
        "fullPageWrites": "off"
      }
```

To install the chart with the release name `openstreetmaps-tile-server`:

```console
helm upgrade --install openstreetmaps-tile-server robjuz/openstreetmaps-tile-server -f values.yaml
```

### App deployment

You need to set ```openstreetmaps-tile-serverInitialize.enabled: false``` 

You also should remove the ```postgresqlExtendedConf```

```yaml
  openstreetmaps-tile-serverInitialize:
    enabled: false

  postgresql:
    postgresqlExtendedConf:
```

To install the chart with the release name `openstreetmaps-tile-server`:

```console
helm upgrade --install openstreetmaps-tile-server robjuz/openstreetmaps-tile-server -f values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `openstreetmaps-tile-server` deployment:

```console
helm delete openstreetmaps-tile-server
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Common parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `nameOverride`      | String to partially override common.names.fullname | `nil`           |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil`           |

### openstreetmaps-tile-server Image parameters

| Name                | Description                                          | Value                 |
| ------------------- | ---------------------------------------------------- | --------------------- |
| `image.repository`  | openstreetmaps-tile-server image repository                               | `mediagis/openstreetmaps-tile-server`        |
| `image.tag`         | openstreetmaps-tile-server image tag (immutable tags are recommended)     | `3.7` |
| `image.pullPolicy`  | openstreetmaps-tile-server image pull policy                              | `IfNotPresent`        |
| `imagePullSecrets`  | openstreetmaps-tile-server image pull secrets                             | `[]`                  |

### openstreetmaps-tile-server Configuration parameters

| Name                                   | Description                           | Value                |
| -------------------------------------- | ------------------------------------- | -------------------- |
| `openstreetmaps-tile-serverAdminEmail`                      | Email for the superadmin account      | `admin@openstreetmaps-tile-server.local`  |
| `openstreetmaps-tile-serverAdminPassword`                   | Password for the superadmin account   | `changemeplease`     |
| `openstreetmaps-tile-serverEnvironment`                     | openstreetmaps-tile-server environment name                | `prod`               |

### openstreetmaps-tile-server Initialisation Configuration parameters

| Name                                       | Description                                                   | Value                |
| ------------------------------------------ | ------------------------------------------------------------- | -------------------- |
| `openstreetmaps-tile-serverInitialize.enabled`              | enable/disable init job                                       | `false `             |
| `openstreetmaps-tile-serverInitialize.pbfUrl`               | URL of the pbf file to import                                 | `https://download.geofabrik.de/europe/germany/sachsen-latest.osm.pbf` |
| `openstreetmaps-tile-serverInitialize.importWikipedia`      | If additional Wikipedia/Wikidata rankings should be imported  | `false`               |
| `openstreetmaps-tile-serverInitialize.importGB_Postcode`    | If external GB postcodes should be imported                   | `false`               |
| `openstreetmaps-tile-serverInitialize.importUS_Postcode`    | If external US postcodes should be imported                   | `false`               |
| `openstreetmaps-tile-serverInitialize.importStyle`          | openstreetmaps-tile-server import style                                        | `full`                |
| `openstreetmaps-tile-serverInitialize.threads`              | The number of thread used by the import                       | `16`                  |

### openstreetmaps-tile-server Replication Configuration parameters

| Name                                       | Description                     | Value                |
| ------------------------------------------ | ------------------------------- | -------------------- |
| `openstreetmaps-tile-serverReplications.enabled`            | enable/disable replication      | `false `             |
| `openstreetmaps-tile-serverReplications.replicationUrl`     | URL with update information     | `https://download.geofabrik.de/europe/germany/sachsen-updates/` |

### openstreetmaps-tile-server Configuration parameters

| Name                                       | Description                      | Value                |
| ----------------------------------- | ------------------------------- | -------------------- |
| `openstreetmaps-tile-server.projectDir`              | openstreetmaps-tile-server Project Directory     | `/openstreetmaps-tile-server `             |
| `openstreetmaps-tile-server.databaseModulePath`      | Path on the database server there the openstreetmaps-tile-server module can be found   | `/bitnami` |

### openstreetmaps-tile-server deployment parameters

| Name                                    | Description                                                | Value           |
| --------------------------------------- | -----------------------------------------------------------| --------------- |
| `replicaCount`                          | Number of openstreetmaps-tile-server replicas to deploy                         | `1`             |
| `updateStrategy.type`                   | openstreetmaps-tile-server deployment strategy type                             | `RollingUpdate` |
| `updateStrategy.rollingUpdate`          | openstreetmaps-tile-server deployment rolling update configuration parameters   | `{}`            |
| `schedulerName`                         | Alternate scheduler                                        | `nil`           |
| `serviceAccountName`                    | ServiceAccount name                                        | `default`       |
| `podAnnotations`                        | Annotations for openstreetmaps-tile-server pods                                 | `{}`            |

### Traffic Exposure Parameters

| Name                               | Description                                                                      | Value          |
| ---------------------------------- | ---------------------------------------------------------------------------------| -------------- |
| `service.type`                     | openstreetmaps-tile-server service type                                                               | `ClusterIP`    |
| `service.port`                     | openstreetmaps-tile-server service HTTP port                                                          | `80`           |
| `ingress.enabled`                  | Enable ingress record generation for openstreetmaps-tile-server                                       | `false`        |
| `ingress.certManager`              | Add the corresponding annotations for cert-manager integration                   | `false`        |
| `ingress.hostname`                 | Default host for the ingress record                                              | `openstreetmaps-tile-server.local`  |
| `ingress.annotations`              | Additional custom annotations for the ingress record                             | `{}`           |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter    | `false`        |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                               | `[]`           |

### persistence Parameters

| Name                                          | Description                                                | Value             |
| --------------------------------------------- | -----------------------------------------------------------| ----------------- |
| `persistence.enabled`                         | Enable persistence using Persistent Volume Claims             | `false`            |
| `persistence.storageClass`                    | Persistent Volume storage class                            | `nil`             |
| `persistence.accessModes`                     | Persistent Volume access modes                             | `[ReadWriteMany]` |
| `persistence.size`                            | Persistent Volume size                                     | `100Gi`             |
| `persistence.existingClaim`                   | The name of an existing PVC to use for persistence            | `nil`             |

### Database Parameters

| Name                                     | Description                                                                  | Value                         |
| ---------------------------------------- | ---------------------------------------------------------------------------- | ----------------------------- |
| `postgresql.enabled`                     | Deploy a PostgreSQL server to satisfy the applications database requirements | `true`                        |
| `postgresql.image.repository`            | PostgreSQL image repository                                                  | `robjuz/postgresql-openstreetmaps-tile-server` |
| `postgresql.image.tag`                   | PostgreSQL image tag                                                         | `latest`                      |
| `postgresql.postgresqlPostgresPassword`  | PostgreSQL root password                                                     | `openstreetmaps-tile-server`                   |
| `postgresql.postgresqlUsername`          | PostgreSQL read-only user (this should be not changed)                       | `www-data`                    |
| `postgresql.postgresqlPassword`          | PostgreSQL database password                                                 | `openstreetmaps-tile-server`                   |
| `postgresql.postgresqlDatabase`          | PostgreSQL database name                                                     | `openstreetmaps-tile-server`                   |
| `postgresql.persistence.enabled`         | Enable persistence on PostgreSQL using PVC(s)                                | `true`                        |
| `postgresql.persistence.storageClass`    | Persistent Volume storage class                                              | `nil`                         |
| `postgresql.persistence.accessModes`     | Persistent Volume access modes                                            | `[ReadWriteOnce]`                |
| `postgresql.persistence.size`            | Persistent Volume size                                                    | `500Gi`                          |

## Configuration and installation details

### persistence support

When importing large extracts (Europe/Planet) the usage of persistence is recommended. 
Using persistence with replication enabled requires the usage of a ReadWriteMany volume, because the persistence file needs to be shared within the pods.
This also applies when scaling the openstreetmaps-tile-server deployment.

### External database support

You may want to have openstreetmaps-tile-server connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#database-parameters). You should also disable the PostgreSQL installation with the `postgresql.enabled` option. Here is an example:

```console
postgresql.enabled: false
externalDatabase.host=myexternalhost
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve openstreetmaps-tile-server.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management.