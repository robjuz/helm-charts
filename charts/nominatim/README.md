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
          full_page_writes = off
```

To install the chart with the release name `nominatim`:

```console
helm upgrade --install nominatim robjuz/nominatim -f values.yaml
```

### App deployment

You need to set ```nominatimInitialize.enabled: false```

You also should remove the ```postgresql.primary.extendedConfiguration```

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

The command removes all the Kubernetes components associated with the chart and deletes the release, but the imported data still remains.

## Removing persisted data
For a total uninstallation of nomination, a data removal is necessary. To do so, first of all, you need to search for the right persistence volume. To indetify it, you need to type de command below, and search for a volume containing the helm release name.

```console
kubectl get pvc
```

You'll receive an output similar to:

| NAME                        | STATUS | VOLUME                                   | CAPACITY | ACCESS MODES | STORAGECLASS | AGE  |
| --------------------------- | ------ | ---------------------------------------- | -------- | ------------ | ------------ | ---- |
| data-nominatim-postgresql-0 | Bound  | pvc-b450c62d-d888-4869-9568-298e6d10b597 | 500Gi    | RWO          | standard     | 3d1h |

Once you found the correct PVC, you just need to type de command to delete it:

```console
kubectl delete pvc data-nominatim-postgresql-0
```

Or, you may use a single command for both operation, like following:

```console
kubectl delete pvc -l app.kubernetes.io/instance=nominatim
```

Note: The command above may differ a little depending the k8s cluster version you're using.

## Parameters

### Common parameters

| Name               | Description                                        | Value |
|--------------------|----------------------------------------------------|-------|
| `nameOverride`     | String to partially override common.names.fullname | `nil` |
| `fullnameOverride` | String to fully override common.names.fullname     | `nil` |

### Nominatim Image parameters

| Name               | Description                                          | Value                |
|--------------------|------------------------------------------------------|----------------------|
| `image.repository` | Nominatim image repository                           | `mediagis/nominatim` |
| `image.tag`        | Nominatim image tag (immutable tags are recommended) | `3.7`                |
| `image.pullPolicy` | Nominatim image pull policy                          | `IfNotPresent`       |
| `imagePullSecrets` | Nominatim image pull secrets                         | `[]`                 |

### Nominatim Configuration parameters

| Name                     | Description                         | Value                   |
|--------------------------|-------------------------------------|-------------------------|
| `NominatimAdminEmail`    | Email for the superadmin account    | `admin@Nominatim.local` |
| `NominatimAdminPassword` | Password for the superadmin account | `changemeplease`        |
| `NominatimEnvironment`   | Nominatim environment name          | `prod`                  |

### Nominatim Initialisation Configuration parameters

| Name                                    | Description                                                  | Value                                                                 |
|-----------------------------------------|--------------------------------------------------------------|-----------------------------------------------------------------------|
| `nominatimInitialize.enabled`           | enable/disable init job                                      | `false `                                                              |
| `nominatimInitialize.pbfUrl`            | URL of the pbf file to import                                | `https://download.geofabrik.de/europe/germany/sachsen-latest.osm.pbf` |
| `nominatimInitialize.importWikipedia`   | If additional Wikipedia/Wikidata rankings should be imported | `false`                                                               |
| `nominatimInitialize.wikipediaUrl`      | Wikipedia/Wikidata rankings file URL                         | `https://nominatim.org/data/wikimedia-importance.sql.gz`              |
| `nominatimInitialize.importGB_Postcode` | If external GB postcodes should be imported                  | `false`                                                               |
| `nominatimInitialize.importUS_Postcode` | If external US postcodes should be imported                  | `false`                                                               |
| `nominatimInitialize.importStyle`       | Nominatim import style                                       | `full`                                                                |
| `nominatimInitialize.customStyleUrl`    | Custom import style file URL                                 | `nil`                                                                 |
| `nominatimInitialize.threads`           | The number of thread used by the import                      | `16`                                                                  |
| `nominatimInitialize.resources`         | Define resources requests and limits for the init container  | `{}`                                                                  |

### Nominatim Replication Configuration parameters

| Name                                   | Description                                             | Value                                                           |
|----------------------------------------|---------------------------------------------------------|-----------------------------------------------------------------|
| `nominatimReplications.enabled`        | enable/disable replication                              | `false `                                                        |
| `nominatimReplications.replicationUrl` | URL with update information                             | `https://download.geofabrik.de/europe/germany/sachsen-updates/` |
| `nominatimReplications.resources`      | Define resources requests and limits for the update job | `{}`                                                            |
| `nominatimReplications.threads`        | Amount of threads to use                                | `1`                                                             |

### Nominatim deployment parameters

| Name                           | Description                                                  | Value           |
|--------------------------------|--------------------------------------------------------------|-----------------|
| `replicaCount`                 | Number of Nominatim replicas to deploy                       | `1`             |
| `updateStrategy.type`          | Nominatim deployment strategy type                           | `RollingUpdate` |
| `updateStrategy.rollingUpdate` | Nominatim deployment rolling update configuration parameters | `{}`            |
| `schedulerName`                | Alternate scheduler                                          | `nil`           |
| `serviceAccountName`           | ServiceAccount name                                          | `default`       |
| `podAnnotations`               | Annotations for Nominatim pods                               | `{}`            |

### Traffic Exposure Parameters

| Name                       | Description                                                                   | Value             |
|----------------------------|-------------------------------------------------------------------------------|-------------------|
| `service.type`             | Nominatim service type                                                        | `ClusterIP`       |
| `service.port`             | Nominatim service HTTP port                                                   | `80`              |
| `ingress.enabled`          | Enable ingress record generation for Nominatim                                | `false`           |
| `ingress.certManager`      | Add the corresponding annotations for cert-manager integration                | `false`           |
| `ingress.ingressClassName` | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+) |                   |
| `ingress.hostname`         | Default host for the ingress record                                           | `Nominatim.local` |
| `ingress.annotations`      | Additional custom annotations for the ingress record                          | `{}`              |
| `ingress.tls`              | Enable TLS configuration for the host defined at `ingress.hostname` parameter | `false`           |
| `ingress.secrets`          | Custom TLS certificates as secrets                                            | `[]`              |

### Flatnode Parameters

| Name                     | Description                                     | Value             |
|--------------------------|-------------------------------------------------|-------------------|
| `flatnode.enabled`       | Enable flatnode using Persistent Volume Claims  | `false`           |
| `flatnode.storageClass`  | Persistent Volume storage class                 | `nil`             |
| `flatnode.accessModes`   | Persistent Volume access modes                  | `[ReadWriteMany]` |
| `flatnode.size`          | Persistent Volume size                          | `100Gi`           |
| `flatnode.existingClaim` | The name of an existing PVC to use for flatnode | `nil`             |


### Data PVC Parameters


| Name                    | Description                                            | Value             |
|-------------------------|--------------------------------------------------------|-------------------|
| `datapvc.enabled`       | Enable Data persistence using Persistent Volume Claims | `false`           |
| `datapvc.storageClass`  | Persistent Volume storage class                        | `nil`             |
| `datapvc.accessModes`   | Persistent Volume access modes                         | `[ReadWriteMany]` |
| `datapvc.size`          | Persistent Volume size                                 | `100Gi`           |
| `datapvc.existingClaim` | The name of an existing PVC                            | `nil`             |


### Database Parameters

| Name                                          | Description                                                                                                                              | Value                         |
|-----------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------|
| `postgresql.enabled`                          | Deploy a PostgreSQL server to satisfy the applications database requirements                                                             | `true`                        |
| `postgresql.image.repository`                 | PostgreSQL image repository                                                                                                              | `robjuz/postgresql-nominatim` |
| `postgresql.image.tag`                        | PostgreSQL image tag                                                                                                                     | `14.4.0-4.0.1`                |
| `postgresql.auth.postgresPassword`            | PostgreSQL root password                                                                                                                 | `nominatim`                   |
| `postgresql.primary.persistence.enabled`      | Enable persistence on PostgreSQL using PVC(s)                                                                                            | `true`                        |
| `postgresql.primary.persistence.storageClass` | Persistent Volume storage class                                                                                                          | `nil`                         |
| `postgresql.primary.persistence.accessModes`  | Persistent Volume access modes                                                                                                           | `[ReadWriteOnce]`             |
| `postgresql.primary.persistence.size`         | Persistent Volume size                                                                                                                   | `500Gi`                       |
| `externalDatabase.host`                       | External PostgreSQL host (ignored if `postgresql.enabled = true`)                                                                        | localhost                     |
| `externalDatabase.port`                       | External PostgreSQL post (ignored if `postgresql.enabled = true`)                                                                        | 5432                          |
| `externalDatabase.user`                       | External PostgreSQL user (ignored if `postgresql.enabled = true`)                                                                        | nominatim                     |
| `externalDatabase.password`                   | External PostgreSQL password (ignored if `postgresql.enabled = true`)                                                                    | ""                            |
| `externalDatabase.existingSecretDsn`          | Name of existing secret to use to set full PostgreSQL DataSourceName (overrides `externalDatabase.*`)                                    | `nil`                         |
| `externalDatabase.existingSecretDsnKey`       | Name of key in existing secret to use to set full PostgreSQL DataSourceName. Only used when `externalDatabase.existingSecretDsn` is set. | POSTGRESQL_DSN                |

### Nominatim Appserver Parameters

| Name                            | Description                              | Value                              |
|---------------------------------|------------------------------------------|------------------------------------|
| `nominatim.extraEnv`            | Additional environment variables to set. | `[]`                               |

### Nominatim UI Parameters

| Name                              | Description                                                                                                                                     | Value           |
|-----------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|
| `nominatimUi.enabled`             | Installs and serves an instance of the Nominatim Demo UI. (Same as the one [hosted by OSM](https://nominatim.openstreetmap.org/ui/search.html)) | `true`          |
| `nominatimUi.version`             | Version of Nominatim UI to install. (See their [GitHub project](https://github.com/osm-search/nominatim-ui/) for reference)                     | `3.2.1`         |
| `nominatimUi.apacheConfiguration` | Apache Webserver configuration. You have to restart the appserver when you make changes while nominatim is running.                             | see values.yaml |
| `nominatimUi.configuration`       | Additional Nominatim configuration.                                                                                                             | see values.yaml |


## Configuration and installation details

### Flatnode support

When importing large extracts (Europe/Planet) the usage of flatnode is recommended.
Using flatnode with replication enabled requires the usage of a ReadWriteMany volume, because the flatnode file needs to be shared within the pods.
This also applies when scaling the nominatim deployment.

### PVC For data

When importing large extracts (Europe/Planet) there data needed to be downloaded are quite big. If you server has not enought disk space to store the data, you can use a dedicated PV for this.

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

#### Using an existing secret to connect to the database

You may want to use an existing secret to configure the connection to the database for your needs. To do so, you can use the `externalDatabase.existingSecretDsn` and `externalDatabase.existingSecretDsnKey` parameters. The secret must contain a key with the name specified in `externalDatabase.existingSecretDsnKey` and the value must be a valid PostgreSQL DataSourceName. Here is an example:

```console
externalDatabase.existingSecretDsn=my-secret
externalDatabase.existingSecretDsnKey=POSTGRESQL_DSN
```

With a secret like this:

```console
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
data:
  POSTGRESQL_DSN: pgsql:host=release-name-postgresql;port=5432;user=postgres;password=nominatim;dbname=nominatim
```

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve Nominatim.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

### Custom Import Style

If none of the [default styles](https://nominatim.org/release-docs/latest/admin/Import/#filtering-imported-data) satisfies your needs, you can provide your [customized style file](https://nominatim.org/release-docs/latest/customize/Import-Styles/) by setting the `nominatimInitialize.customStyleUrl` value.

Make sure the file is publicly available for init job to download it. [Example](https://raw.githubusercontent.com/osm-search/Nominatim/master/settings/import-street.style)
### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management.
