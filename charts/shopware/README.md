# Shopware 6

[Shopware 6](https://www.shopware.com/en/products/shopware-6/) offers all online merchants maximum flexibility, the freedom to grow and focus on the perfect customer experience. Shopware 6 is the ecommerce solution for all conceivable channels of the present and future.

## TL;DR

```console
$ helm repo add robjuz https://robjuz.github.io/helm-charts/
$ helm install shopware robjuz/shopware
```

## Introduction

This chart bootstraps a [Shopware](https://github.com/shyim/shopware) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Shopware application, 
the [Bitnami Elasticsearch chart](https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch) that is used to indexing, 
the [Bitnami Minio chart](https://github.com/bitnami/charts/tree/master/bitnami/minio) that is used to store documents, media, theme, asset and sitemap files

This chart has been tested to work with NGINX Ingress, cert-manager and Prometheus on top of the [k3s](https://k3s.io/).

## Prerequisites

- Kubernetes 1.19+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling (only when installing external plugins)

## Installing the Chart

To install the chart with the release name `shopware`:

```console
helm install shopware robjuz/shopware
```

The command deploys Shopware on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `shopware` deployment:

```console
helm delete shopware
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
|---------------------------|-------------------------------------------------|-------|
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                | Description                                        | Value           |
|---------------------|----------------------------------------------------|-----------------|
| `kubeVersion`       | Override Kubernetes version                        | `""`            |
| `nameOverride`      | String to partially override common.names.fullname | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`            |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                     | `cluster.local` |


### Shopware Image parameters

| Name                | Description                                         | Value            |
|---------------------|-----------------------------------------------------|------------------|
| `image.registry`    | Shopware image registry                             | `docker.io`      |
| `image.repository`  | Shopware image repository                           | `shyim/shopware` |
| `image.tag`         | Shopware image tag (immutable tags are recommended) | `6.4.6.0`        |
| `image.pullPolicy`  | Shopware image pull policy                          | `IfNotPresent`   |
| `image.pullSecrets` | Shopware image pull secrets                         | `[]`             |
| `image.debug`       | Enable image debug mode                             | `false`          |


### Shopware Configuration parameters

| Name                   | Description                                                                                 | Value              |
|------------------------|---------------------------------------------------------------------------------------------|--------------------|
| `shopwareUsername`     | Shopware admin username                                                                     | `admin`            |
| `shopwarePassword`     | Shopware admin password (Defaults to a random 10-character alphanumeric string if not set ) | `""`               |
| `shopwareLocale`       | Shopware default language                                                                   | `de-DE`            |
| `shopwareCurrency`     | Shopware default currency                                                                   | `EUR`              |
| `shopwareAppEnv`       | Shopware environment                                                                        | `prod`             |
| `shopwareInstanceId`   | Shopware instance ID (Defaults to a random 64-character alphanumeric string if not set )    | `""`               |
| `shopwareAppUrl`       | Shopware URL                                                                                | `""`               |
| `shopwareAppSecret`    | Shopware Secret (Defaults to a random 64-character alphanumeric string if not set )         | `""`               |
| `mailerUrl`            | Mailer URL                                                                                  | `null://localhost` |
| `activePlugins`        | Comma separated list of plugins that should be activated                                    | `""`               |
| `httpCache.enabled`    | Enable http cache                                                                           | `true`             |
| `httpCache.defaultTtl` | Http cache default Time to live                                                             | `7200`             |
| `cache.adapter`        | Adapter to use for caching                                                                  | `redis`            |
| `cache.database`       | Database to use for caching                                                                 | `0`                |
| `session.adapter`      | Adapter to use for session                                                                  | `redis`            |
| `session.database`     | Database to use for session                                                                 | `1`                |


### Shopware deployment parameters

| Name                                    | Description                                                                               | Value           |
|-----------------------------------------|-------------------------------------------------------------------------------------------|-----------------|
| `replicaCount`                          | Number of Shopware replicas to deploy                                                     | `1`             |
| `updateStrategy.type`                   | Shopware deployment strategy type                                                         | `RollingUpdate` |
| `updateStrategy.rollingUpdate`          | Shopware deployment rolling update configuration parameters                               | `{}`            |
| `schedulerName`                         | Alternate scheduler                                                                       | `""`            |
| `serviceAccountName`                    | ServiceAccount name                                                                       | `default`       |
| `hostAliases`                           | Shopware pod host aliases                                                                 | `[]`            |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for Shopware pods                     | `[]`            |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for Shopware container(s)        | `[]`            |
| `extraContainerPorts`                   | Optionally specify extra list of additional ports for Shopware container(s)               | `[]`            |
| `sidecars`                              | Add additional sidecar containers to the Shopware pod                                     | `[]`            |
| `initContainers`                        | Add additional init containers to the Shopware pods                                       | `[]`            |
| `podLabels`                             | Extra labels for Shopware pods                                                            | `{}`            |
| `podAnnotations`                        | Annotations for Shopware pods                                                             | `{}`            |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set                                     | `""`            |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set                                  | `[]`            |
| `affinity`                              | Affinity for pod assignment                                                               | `{}`            |
| `nodeSelector`                          | Node labels for pod assignment                                                            | `{}`            |
| `tolerations`                           | Tolerations for pod assignment                                                            | `[]`            |
| `resources.limits`                      | The resources limits for the Shopware container                                           | `{}`            |
| `resources.requests`                    | The requested resources for the Shopware container                                        | `{}`            |
| `containerPorts.http`                   | Shopware HTTP container port                                                              | `8080`          |
| `containerPorts.https`                  | Shopware HTTPS container port                                                             | `8443`          |
| `podSecurityContext.enabled`            | Enabled Shopware pods' Security Context                                                   | `true`          |
| `podSecurityContext.fsGroup`            | Set Shopware pod's Security Context fsGroup                                               | `1001`          |
| `containerSecurityContext.enabled`      | Enabled Shopware containers' Security Context                                             | `true`          |
| `containerSecurityContext.runAsUser`    | Set Shopware container's Security Context runAsUser                                       | `1001`          |
| `containerSecurityContext.runAsNonRoot` | Set Shopware container's Security Context runAsNonRoot                                    | `true`          |
| `livenessProbe.enabled`                 | Enable livenessProbe                                                                      | `true`          |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                   | `120`           |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                          | `10`            |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                         | `5`             |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                       | `6`             |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                       | `1`             |
| `readinessProbe.enabled`                | Enable readinessProbe                                                                     | `true`          |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                  | `30`            |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                         | `10`            |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                        | `5`             |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                      | `6`             |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                      | `1`             |
| `customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                       | `{}`            |
| `customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                      | `{}`            |

### Shopware Task Runner deployment parameters

| Name                                      | Description                                                                               | Value           |
|-------------------------------------------|-------------------------------------------------------------------------------------------|-----------------|
| `taskRunner.enabled`                      | Deploy Task Runner                                                                        | `true`          |
| `taskRunner.replicaCount`                 | Number of Task Runner replicas to deploy                                                  | `1`             |
| `taskRunner.hostAliases`                  | Shopware pod host aliases                                                                 | `[]`            |
| `taskRunner.podLabels`                    | Extra labels for Shopware pods                                                            | `{}`            |
| `taskRunner.podAnnotations`               | Annotations for Shopware pods                                                             | `{}`            |
| `taskRunner.podAffinityPreset`            | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `taskRunner.podAntiAffinityPreset`        | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `taskRunner.nodeAffinityPreset.type`      | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `taskRunner.nodeAffinityPreset.key`       | Node label key to match. Ignored if `affinity` is set                                     | `""`            |
| `taskRunner.nodeAffinityPreset.values`    | Node label values to match. Ignored if `affinity` is set                                  | `[]`            |
| `taskRunner.affinity`                     | Affinity for pod assignment                                                               | `{}`            |
| `taskRunner.nodeSelector`                 | Node labels for pod assignment                                                            | `{}`            |

### Shopware Consumer deployment parameters

| Name                                    | Description                                                                               | Value           |
|-----------------------------------------|-------------------------------------------------------------------------------------------|-----------------|
| `consumer.enabled`                      | Deploy Task Runner                                                                        | `true`          |
| `consumer.replicaCount`                 | Number of Task Runner replicas to deploy                                                  | `2`             |
| `consumer.podLabels`                    | Extra labels for Shopware pods                                                            | `{}`            |
| `consumer.podAnnotations`               | Annotations for Shopware pods                                                             | `{}`            |
| `consumer.podAffinityPreset`            | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`            |
| `consumer.podAntiAffinityPreset`        | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`          |
| `consumer.nodeAffinityPreset.type`      | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`            |
| `consumer.nodeAffinityPreset.key`       | Node label key to match. Ignored if `affinity` is set                                     | `""`            |
| `consumer.nodeAffinityPreset.values`    | Node label values to match. Ignored if `affinity` is set                                  | `[]`            |
| `consumer.affinity`                     | Affinity for pod assignment                                                               | `{}`            |
| `consumer.nodeSelector`                 | Node labels for pod assignment                                                            | `{}`            |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
|------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|--------------------------|
| `service.type`                     | Shopware service type                                                                                                            | `LoadBalancer`           |
| `service.port`                     | Shopware service HTTP port                                                                                                       | `80`                     |
| `service.httpsPort`                | Shopware service HTTPS port                                                                                                      | `443`                    |
| `service.httpsTargetPort`          | Target port for HTTPS                                                                                                            | `https`                  |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                               | `""`                     |
| `service.nodePorts.https`          | Node port for HTTPS                                                                                                              | `""`                     |
| `service.clusterIP`                | Shopware service Cluster IP                                                                                                      | `""`                     |
| `service.loadBalancerIP`           | Shopware service Load Balancer IP                                                                                                | `""`                     |
| `service.loadBalancerSourceRanges` | Shopware service Load Balancer sources                                                                                           | `[]`                     |
| `service.externalTrafficPolicy`    | Shopware service external traffic policy                                                                                         | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Shopware service                                                                               | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Shopware service                                                                                         | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Shopware                                                                                    | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `shopware.local`         |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |


### Persistence Parameters

| Name                                          | Description                                                                                     | Value                   |
|-----------------------------------------------|-------------------------------------------------------------------------------------------------|-------------------------|
| `persistence.enabled`                         | Enable persistence using Persistent Volume Claims                                               | `true`                  |
| `persistence.storageClass`                    | Persistent Volume storage class                                                                 | `""`                    |
| `persistence.accessModes`                     | Persistent Volume access modes                                                                  | `[]`                    |
| `persistence.size`                            | Persistent Volume size                                                                          | `10Gi`                  |
| `persistence.dataSource`                      | Custom PVC data source                                                                          | `{}`                    |
| `persistence.existingClaim`                   | The name of an existing PVC to use for persistence                                              | `""`                    |
| `volumePermissions.enabled`                   | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                 |
| `volumePermissions.image.registry`            | Bitnami Shell image registry                                                                    | `docker.io`             |
| `volumePermissions.image.repository`          | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                 | Bitnami Shell image tag (immutable tags are recommended)                                        | `10-debian-10-r247`     |
| `volumePermissions.image.pullPolicy`          | Bitnami Shell image pull policy                                                                 | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`         | Bitnami Shell image pull secrets                                                                | `[]`                    |
| `volumePermissions.resources.limits`          | The resources limits for the init container                                                     | `{}`                    |
| `volumePermissions.resources.requests`        | The requested resources for the init container                                                  | `{}`                    |
| `volumePermissions.securityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                     |


### Other Parameters

| Name                               | Description                                                    | Value   |
|------------------------------------|----------------------------------------------------------------|---------|
| `pdb.create`                       | Enable a Pod Disruption Budget creation                        | `false` |
| `pdb.minAvailable`                 | Minimum number/percentage of pods that should remain scheduled | `1`     |
| `pdb.maxUnavailable`               | Maximum number/percentage of pods that may be made unavailable | `""`    |
| `autoscaling.enabled`              | Enable Horizontal POD autoscaling for Shopware                 | `false` |
| `autoscaling.minReplicas`          | Minimum number of Shopware replicas                            | `1`     |
| `autoscaling.maxReplicas`          | Maximum number of Shopware replicas                            | `11`    |
| `autoscaling.targetCPU`            | Target CPU utilization percentage                              | `50`    |
| `autoscaling.targetMemory`         | Target Memory utilization percentage                           | `50`    |
| `consumer.autoscaling.enabled`     | Enable Horizontal POD autoscaling for Shopware Consumer        | `false` |
| `consumer.autoscaling.minReplicas` | Minimum number of Shopware Consumer replicas                   | `1`     |
| `consumer.autoscaling.maxReplicas` | Maximum number of Shopware Consumer replicas                   | `11`    |
| `consumer.autoscaling.targetCPU`   | Target CPU utilization percentage                              | `50`    |


### Metrics Parameters

| Name                                      | Description                                                                  | Value                    |
|-------------------------------------------|------------------------------------------------------------------------------|--------------------------|
| `metrics.enabled`                         | Start a sidecar prometheus exporter to expose metrics                        | `false`                  |
| `metrics.image.registry`                  | Apache Exporter image registry                                               | `docker.io`              |
| `metrics.image.repository`                | Apache Exporter image repository                                             | `bitnami/nginx-exporter` |
| `metrics.image.tag`                       | Apache Exporter image tag (immutable tags are recommended)                   | `0.9.0-debian-10-r242`   |
| `metrics.image.pullPolicy`                | Apache Exporter image pull policy                                            | `IfNotPresent`           |
| `metrics.image.pullSecrets`               | Apache Exporter image pull secrets                                           | `[]`                     |
| `metrics.resources.limits`                | The resources limits for the Prometheus exporter container                   | `{}`                     |
| `metrics.resources.requests`              | The requested resources for the Prometheus exporter container                | `{}`                     |
| `metrics.service.port`                    | Metrics service port                                                         | `9113`                   |
| `metrics.service.annotations`             | Additional custom annotations for Metrics service                            | `{}`                     |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator | `false`                  |
| `metrics.serviceMonitor.namespace`        | The namespace in which the ServiceMonitor will be created                    | `""`                     |
| `metrics.serviceMonitor.interval`         | The interval at which metrics should be scraped                              | `30s`                    |
| `metrics.serviceMonitor.scrapeTimeout`    | The timeout after which the scrape is ended                                  | `""`                     |
| `metrics.serviceMonitor.relabellings`     | Metrics relabellings to add to the scrape endpoint                           | `[]`                     |
| `metrics.serviceMonitor.honorLabels`      | Labels to honor to add to the scrape endpoint                                | `false`                  |
| `metrics.serviceMonitor.additionalLabels` | Additional custom labels for the ServiceMonitor                              | `{}`                     |


### Database Parameters

| Name                                       | Description                                                               | Value              |
|--------------------------------------------|---------------------------------------------------------------------------|--------------------|
| `mariadb.enabled`                          | Deploy a MariaDB server to satisfy the applications database requirements | `true`             |
| `mariadb.architecture`                     | MariaDB architecture. Allowed values: `standalone` or `replication`       | `standalone`       |
| `mariadb.auth.rootPassword`                | MariaDB root password                                                     | `""`               |
| `mariadb.auth.database`                    | MariaDB custom database                                                   | `bitnami_shopware` |
| `mariadb.auth.username`                    | MariaDB custom user name                                                  | `bn_shopware`      |
| `mariadb.auth.password`                    | MariaDB custom user password                                              | `""`               |
| `mariadb.primary.persistence.enabled`      | Enable persistence on MariaDB using PVC(s)                                | `true`             |
| `mariadb.primary.persistence.storageClass` | Persistent Volume storage class                                           | `""`               |
| `mariadb.primary.persistence.accessModes`  | Persistent Volume access modes                                            | `[]`               |
| `mariadb.primary.persistence.size`         | Persistent Volume size                                                    | `8Gi`              |
| `externalDatabase.host`                    | External Database server host                                             | `localhost`        |
| `externalDatabase.port`                    | External Database server port                                             | `3306`             |
| `externalDatabase.user`                    | External Database username                                                | `shopware`         |
| `externalDatabase.password`                | External Database user password                                           | `""`               |
| `externalDatabase.database`                | External Database database name                                           | `shopware`         |
| `externalDatabase.existingSecret`          | The name of an existing secret with database credentials                  | `""`               |
| `redis.enabled`                            | Deploy a Redis server for caching                                         | `true`             |
| `externalCache.host`                       | External cache server host                                                | `localhost`        |
| `externalCache.port`                       | External cache server port                                                | `6379`             |
| `elasticsearch.enabled`                    | Deploy a Elasticsearch server for indexing                                | `true`             |
| `externalElasticsearch.host`               | External Elasticsearch host                                               | `""`               |


The above parameters map to the env variables defined in [bitnami/shopware](http://github.com/bitnami/bitnami-docker-shopware). For more information please refer to the [bitnami/shopware](http://github.com/bitnami/bitnami-docker-shopware) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set shopwareUsername=admin \
  --set shopwarePassword=shopware \
  --set mariadb.auth.rootPassword=secretpassword \
    bitnami/shopware
```

The above command sets the Shopware administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml bitnami/shopware
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

### External database support

You may want to have Shopware connect to an external database rather than installing one inside your cluster. Typical reasons for this are to use a managed database service, or to share a common database server for all your applications. To achieve this, the chart allows you to specify credentials for an external database with the [`externalDatabase` parameter](#database-parameters). You should also disable the MariaDB installation with the `mariadb.enabled` option. Here is an example:

```console
mariadb.enabled=false
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

Refer to the [documentation on using an external database with Shopware](https://docs.bitnami.com/kubernetes/apps/shopware/configuration/use-external-database/) and the [tutorial on integrating Shopware with a managed cloud database](https://docs.bitnami.com/tutorials/secure-shopware-kubernetes-managed-database-ssl-upgrades/) for more information.

### Redis

This chart provides support for using Redis to cache objects improving the website performance. To enable this feature, set `cache.adapter` and `redis.enabled` parameters to `true`.

When this feature is enabled, a Redis server will be deployed in your K8s cluster using the Bitnami Redis chart

It is also possible to use an external cache server rather than installing one inside your cluster. To achieve this, the chart allows you to specify credentials for an external cache server with the [`externalCache` parameter](#database-parameters). You should also disable the Redis installation with the `redis.enabled` option. Here is an example:

```console
redis.enabled=false
externalCache.host=myexternalcachehost
externalCache.port=6379
```
### Elasticsearch

This chart provides support for using Elasticsearch to index products improving the website performance. To enable this feature `elasticsearch.enabled` parameters to `true`.

When this feature is enabled, a Elasticsearch server will be deployed in your K8s cluster using the Bitnami Elasticsearch chart

It is also possible to use an external Elasticsearch server rather than installing one inside your cluster. To achieve this, the chart allows you to specify credentials for an external Elasticsearch server with the [`externalElasticsearch` parameter](#database-parameters). You should also disable the Redis installation with the `elasticsearch.enabled` option. Here is an example:

```console
elasticsearch.enabled=false
externalElasticsearch.host=myexternalcachehost
```

### Ingress

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve Shopware.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host.

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for certificate management. [Learn more about TLS secrets](https://docs.bitnami.com/kubernetes/apps/shopware/administration/enable-tls/).

## Persistence

The [Bitnami Shopware](https://github.com/bitnami/bitnami-docker-shopware) image stores the Shopware data and configurations at the `/bitnami` path of the container. Persistent Volume Claims are used to keep the data across deployments.

If you encounter errors when working with persistent volumes, refer to our [troubleshooting guide for persistent volumes](https://docs.bitnami.com/kubernetes/faq/troubleshooting/troubleshooting-persistence-volumes/).

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

### Sidecars

If additional containers are needed in the same pod as Shopware (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/shopware/configuration/configure-sidecar-init-containers/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.
