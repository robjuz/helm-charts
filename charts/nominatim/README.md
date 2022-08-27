# Nominatim

[Nominatim](https://Nominatim.org/) is a tool (an API) to search OSM data by name and address and to generate synthetic addresses of OSM points (reverse geocoding).



## TL;DR

```console
helm repo add robjuz https://robjuz.github.io/helm-charts/
helm install nominatim robjuz/nominatim
```

## Introduction

This chart bootstraps a [Nominatim](https://nominatim.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages a customized [Bitnami PostgreSQL chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) with build nominatim module which is required for bootstrapping a PostgreSQL deployment for the database requirements of the Nominatim application.

This chart has been tested to work with NGINX Ingress and cert-manager on top of the [MicroK8s](https://microk8s.io/).

## Prerequisites

- Kubernetes 1.12+ (ingress requires 1.19+)
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling and flatnode support

## Installing the Chart

The installation consist of 2 steps
1. Initialisation
2. App deployment

### Initialisation
Set```nominatimInitialize.enabled: true```

During the initialization, all required data are downloaded and the database is build.
To improve the import speed you can set additional PostgreSQL params

```yaml
  nominatimInitialize:
    enabled: true
  
  postgresql:
    primary:
        extendedConfiguration: |
          shared_buffers = 2GB
          maintenance_work_mem = 10GB
          autovacuum_work_mem = 2GB
          work_mem = 50MB
          effective_cache_size = 24GB
          synchronous_commit = off
          max_wal_size = 1GB
          checkpoint_timeout = 10min
          checkpoint_completion_target = 0.9
          fsync = off
          fullPageWrites = off
```

To install the chart with the release name `nominatim`:

```console
helm upgrade --install nominatim robjuz/nominatim -f values.yaml
```

### App deployment

You need to set ```nominatimInitialize.enabled: false``` 

You also should remove the ```postgresqlExtendedConf```

```yaml
  nominatimInitialize:
    enabled: false
```

To install the chart with the release name `nominatim`:

```console
helm upgrade --install nominatim robjuz/nominatim -f values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `nominatim` deployment:

```console
helm delete nominatim
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Common parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `nameOverride`      | String to partially override common.names.fullname | `nil`           |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil`           |

### Nominatim Image parameters

| Name                | Description                                          | Value                 |
| ------------------- | ---------------------------------------------------- | --------------------- |
| `image.repository`  | Nominatim image repository                               | `mediagis/nominatim`        |
| `image.tag`         | Nominatim image tag (immutable tags are recommended)     | `3.7` |
| `image.pullPolicy`  | Nominatim image pull policy                              | `IfNotPresent`        |
| `imagePullSecrets`  | Nominatim image pull secrets                             | `[]`                  |

### Nominatim Configuration parameters

| Name                                   | Description                           | Value                |
| -------------------------------------- | ------------------------------------- | -------------------- |
| `NominatimAdminEmail`                      | Email for the superadmin account      | `admin@Nominatim.local`  |
| `NominatimAdminPassword`                   | Password for the superadmin account   | `changemeplease`     |
| `NominatimEnvironment`                     | Nominatim environment name                | `prod`               |

### Nominatim Initialisation Configuration parameters

| Name                                       | Description                                                   | Value                |
| ------------------------------------------ | ------------------------------------------------------------- | -------------------- |
| `nominatimInitialize.enabled`              | enable/disable init job                                       | `false `             |
| `nominatimInitialize.pbfUrl`               | URL of the pbf file to import                                 | `https://download.geofabrik.de/europe/germany/sachsen-latest.osm.pbf` |
| `nominatimInitialize.importWikipedia`      | If additional Wikipedia/Wikidata rankings should be imported  | `false`               |
| `nominatimInitialize.importGB_Postcode`    | If external GB postcodes should be imported                   | `false`               |
| `nominatimInitialize.importUS_Postcode`    | If external US postcodes should be imported                   | `false`               |
| `nominatimInitialize.importStyle`          | Nominatim import style                                        | `full`                |
| `nominatimInitialize.customStyleUrl`       | Custom import style file URL                                  | `nil`                 |
| `nominatimInitialize.threads`              | The number of thread used by the import                       | `16`                  |

### Nominatim Replication Configuration parameters

| Name                                       | Description                     | Value                |
| ------------------------------------------ | ------------------------------- | -------------------- |
| `nominatimReplications.enabled`            | enable/disable replication      | `false `             |
| `nominatimReplications.replicationUrl`     | URL with update information     | `https://download.geofabrik.de/europe/germany/sachsen-updates/` |

### Nominatim deployment parameters

| Name                                    | Description                                                | Value           |
| --------------------------------------- | -----------------------------------------------------------| --------------- |
| `replicaCount`                          | Number of Nominatim replicas to deploy                         | `1`             |
| `updateStrategy.type`                   | Nominatim deployment strategy type                             | `RollingUpdate` |
| `updateStrategy.rollingUpdate`          | Nominatim deployment rolling update configuration parameters   | `{}`            |
| `schedulerName`                         | Alternate scheduler                                        | `nil`           |
| `serviceAccountName`                    | ServiceAccount name                                        | `default`       |
| `podAnnotations`                        | Annotations for Nominatim pods                                 | `{}`            |

### Traffic Exposure Parameters

| Name                               | Description                                                                      | Value          |
| ---------------------------------- | ---------------------------------------------------------------------------------| -------------- |
| `service.type`                     | Nominatim service type                                                               | `ClusterIP`    |
| `service.port`                     | Nominatim service HTTP port                                                          | `80`           |
| `ingress.enabled`                  | Enable ingress record generation for Nominatim                                       | `false`        |
| `ingress.certManager`              | Add the corresponding annotations for cert-manager integration                   | `false`        |
| `ingress.hostname`                 | Default host for the ingress record                                              | `Nominatim.local`  |
| `ingress.annotations`              | Additional custom annotations for the ingress record                             | `{}`           |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter    | `false`        |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                               | `[]`           |

### Flatnode Parameters

| Name                                          | Description                                                | Value             |
| --------------------------------------------- | -----------------------------------------------------------| ----------------- |
| `flatnode.enabled`                         | Enable flatnode using Persistent Volume Claims             | `false`            |
| `flatnode.storageClass`                    | Persistent Volume storage class                            | `nil`             |
| `flatnode.accessModes`                     | Persistent Volume access modes                             | `[ReadWriteMany]` |
| `flatnode.size`                            | Persistent Volume size                                     | `100Gi`             |
| `flatnode.existingClaim`                   | The name of an existing PVC to use for flatnode            | `nil`             |

### Database Parameters

| Name                                          | Description                                                                  | Value                         |
|-----------------------------------------------|------------------------------------------------------------------------------|-------------------------------|
| `postgresql.enabled`                          | Deploy a PostgreSQL server to satisfy the applications database requirements | `true`                        |
| `postgresql.image.repository`                 | PostgreSQL image repository                                                  | `robjuz/postgresql-nominatim` |
| `postgresql.image.tag`                        | PostgreSQL image tag                                                         | `14.4.0-4.0.1`                |
| `postgresql.auth.postgresPassword`            | PostgreSQL root password                                                     | `nominatim`                   |
| `postgresql.primary.persistence.enabled`      | Enable persistence on PostgreSQL using PVC(s)                                | `true`                        |
| `postgresql.primary.persistence.storageClass` | Persistent Volume storage class                                              | `nil`                         |
| `postgresql.primary.persistence.accessModes`  | Persistent Volume access modes                                               | `[ReadWriteOnce]`             |
| `postgresql.primary.persistence.size`         | Persistent Volume size                                                       | `500Gi`                       |
 | `externalDatase.host`                         | External PostgreSQL host (ignored if `postgresql.enabled = true`)            | localhost                     |
 | `externalDatase.port`                         | External PostgreSQL post (ignored if `postgresql.enabled = true`)            | 5432                          |
 | `externalDatase.user`                         | External PostgreSQL user (ignored if `postgresql.enabled = true`)            | nominatim                     |
 | `externalDatase.password`                     | External PostgreSQL password (ignored if `postgresql.enabled = true`)        | ""                            |
## Configuration and installation details

### Flatnode support

When importing large extracts (Europe/Planet) the usage of flatnode is recommended. 
Using flatnode with replication enabled requires the usage of a ReadWriteMany volume, because the flatnode file needs to be shared within the pods.
This also applies when scaling the nominatim deployment.

### External database support

You may want to have Nominatim connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#database-parameters). You should also disable the PostgreSQL installation with the `postgresql.enabled` option. Here is an example:

```console
postgresql.enabled: false
externalDatabase.host=myexternalhost
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

* Make sure the database does not exist when running the init job. The nominatim tool will create a `nominatim` database for you
* Make sure the DB user has superuser rights. The nominatim tool will try to enable the postgis extension and will fail otherwise

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve Nominatim.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

### Custom Import Style

If none of the [default styles](https://nominatim.org/release-docs/latest/admin/Import/#filtering-imported-data) satisfies your needs, you can provide your [customized style file](https://nominatim.org/release-docs/latest/customize/Import-Styles/) by setting the `nominatimInitialize.customStyleUrl` value.

Make sure the file is publicly available for init job to download it. [Example](https://raw.githubusercontent.com/osm-search/Nominatim/master/settings/import-street.style)
### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management.
