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

- Kubernetes 1.19+
- Helm 3.2.0+
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

### Global parameters

| Name                      | Description                                     | Value |
|---------------------------|-------------------------------------------------|-------|
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |

### Common parameters

| Name                     | Description                                                                                  | Value           |
|--------------------------|----------------------------------------------------------------------------------------------|-----------------|
| `kubeVersion`            | Override Kubernetes version                                                                  | `""`            |
| `nameOverride`           | String to partially override common.names.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname template                                      | `""`            |
| `commonLabels`           | Labels to add to all deployed resources                                                      | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed resources                                                 | `{}`            |
| `clusterDomain`          | Kubernetes Cluster Domain                                                                    | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                            | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden)      | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                         | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                            |                 |

### Kimai Image parameters

| Name                | Description                                                                                           | Value                |
|---------------------|-------------------------------------------------------------------------------------------------------|----------------------|
| `image.registry`    | Kimai image registry                                                                                  | `docker.io`          |
| `image.repository`  | Kimai image repository                                                                                | `kimai/kimai2`       |
| `image.tag`         | Kimai image tag (immutable tags are recommended)                                                      | `apache-2.0.23-prod` |
| `image.digest`      | Kimai image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                 |
| `image.pullPolicy`  | Kimai image pull policy                                                                               | `IfNotPresent`       |
| `image.pullSecrets` | Kimai image pull secrets                                                                              | `[]`                 |
| `image.debug`       | Specify if debug values should be set                                                                 |                      |

### Kimai Configuration parameters

| Name                      | Description                                                                                                       | Value                             |
|---------------------------|-------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| `kimaiEnvironment`        | Kimai environment name                                                                                            | `prod`                            |
| `kimaiAppSecret`          | Secret used to encrypt session cookies                                                                            | `change_this_to_something_unique` |
| `kimaiAdminEmail`         | Email for the superadmin account                                                                                  | `admin@example.com`               |
| `kimaiAdminPassword`      | Password for the superadmin account                                                                               | ``                                |
| `kimaiMailerFrom`         | Application specific “from” address for all emails                                                                | `kimai@example.com`               |
| `kimaiMailerUrl`          | SMTP connection for emails                                                                                        | `null://localhost`                |
| `kimaiTrustedProxies`     |                                                                                                                   | `""`                              |
| `kimaiRedisCache`         | Configure Kimai to use Redis as caching  instance. (See redis settings below)                                     | `false`                           |
| `existingSecret`          | Name of existing secret containing Kimai credentials                                                              | `""`                              |
| `configurationFromSecret` | Use an existing secret match the common.names.fullname template containing “local.yaml“ key as configuration file | `false`                           |

### Kimai deployment parameters

| Name                                                | Description                                                                                                              | Value            |
|-----------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|------------------|
| `replicaCount`                                      | Number of Kimai replicas to deploy                                                                                       | `1`              |
| `updateStrategy.type`                               | Kimai deployment strategy type                                                                                           | `RollingUpdate`  |
| `schedulerName`                                     | Alternate scheduler                                                                                                      | `""`             |
| `terminationGracePeriodSeconds`                     | In seconds, time given to the Kimai pod to terminate gracefully                                                          | `""`             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`             |
| `priorityClassName`                                 | Name of the existing priority class to be used by Kimai pods, priority class needs to be created beforehand              | `""`             |
| `hostAliases`                                       | Kimai pod host aliases                                                                                                   | `[]`             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Kimai pods                                                       | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Kimai container(s)                                          | `[]`             |
| `sidecars`                                          | Add additional sidecar containers to the Kimai pod                                                                       | `[]`             |
| `initContainers`                                    | Add additional init containers to the Kimai pods                                                                         | `[]`             |
| `podLabels`                                         | Extra labels for Kimai pods                                                                                              | `{}`             |
| `podAnnotations`                                    | Annotations for Kimai pods                                                                                               | `{}`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                    | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                 | `[]`             |
| `affinity`                                          | Affinity for pod assignment                                                                                              | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                           | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment                                                                                           | `[]`             |
| `resources.limits`                                  | The resources limits for the Kimai containers                                                                            | `{}`             |
| `resources.limits.memory`                           | The memory limit for the Kimai containers                                                                                | `256Mi`          |
| `resources.requests.cpu`                            | The requested cpu for the Kimai containers                                                                               | `100m`           |
| `containerPorts.http`                               | Kimai HTTP container port                                                                                                | `80`             |
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for Kimai container(s)                                                 | `[]`             |
| `podSecurityContext.enabled`                        | Enabled Kimai pods' Security Context                                                                                     | `false`          |
| `podSecurityContext.fsGroup`                        | Set Kimai pod's Security Context fsGroup                                                                                 | `1001`           |
| `podSecurityContext.seccompProfile.type`            | Set Kimai container's Security Context seccomp profile                                                                   | `RuntimeDefault` |
| `containerSecurityContext.enabled`                  | Enabled Kimai containers' Security Context                                                                               | `false`          |
| `containerSecurityContext.runAsUser`                | Set Kimai container's Security Context runAsUser                                                                         | `1001`           |
| `containerSecurityContext.runAsNonRoot`             | Set Kimai container's Security Context runAsNonRoot                                                                      | `true`           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set Kimai container's privilege escalation                                                                               | `false`          |
| `containerSecurityContext.capabilities.drop`        | Set Kimai container's Security Context runAsNonRoot                                                                      | `["ALL"]`        |
| `livenessProbe.enabled`                             | Enable livenessProbe on Kimai containers                                                                                 | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                  | `120`            |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                         | `10`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                        | `5`              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                      | `6`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                      | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe on Kimai containers                                                                                | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                 | `30`             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                        | `10`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                       | `5`              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                     | `6`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                     | `1`              |
| `startupProbe.enabled`                              | Enable startupProbe on Kimai containers                                                                                  | `false`          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                   | `30`             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                          | `10`             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                         | `5`              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                       | `6`              |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                       | `1`              |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                      | `{}`             |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                     | `{}`             |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                       | `{}`             |
| `lifecycleHooks`                                    | for the Kimai container(s) to automate configuration before or after startup                                             | `{}`             |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                                              | Value                    |
|------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------|
| `service.type`                     | Kimai service type                                                                                                                                       | `LoadBalancer`           |
| `service.ports.http`               | Kimai service HTTP port                                                                                                                                  | `80`                     |
| `service.httpsTargetPort`          | Target port for HTTPS                                                                                                                                    | `https`                  |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                                                       | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                                         | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                                              | `{}`                     |
| `service.clusterIP`                | Kimai service Cluster IP                                                                                                                                 | `""`                     |
| `service.loadBalancerIP`           | Kimai service Load Balancer IP                                                                                                                           | `""`                     |
| `service.loadBalancerSourceRanges` | Kimai service Load Balancer sources                                                                                                                      | `[]`                     |
| `service.externalTrafficPolicy`    | Kimai service external traffic policy                                                                                                                    | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Kimai service                                                                                                          | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Kimai service                                                                                                                    | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Kimai                                                                                                               | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                                        | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                                            | `""`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                                            | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record. The hostname is templated and thus can contain other variable references.                                           | `kimai.local`            |
| `ingress.path`                     | Default path for the ingress record                                                                                                                      | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.                         | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                                            | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                                             | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record. The host names are templated and thus can contain other variable references. | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                                                    | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                                                      | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                                                       | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                                                  | `[]`                     |


### Persistence Parameters

| Name                                                   | Description                                                                                                   | Value                   |
|--------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|-------------------------|
| `persistence.enabled`                                  | Enable persistence using Persistent Volume Claims                                                             | `true`                  |
| `persistence.storageClass`                             | Persistent Volume storage class                                                                               | `""`                    |
| `persistence.accessModes`                              | Persistent Volume access modes                                                                                | `[]`                    |
| `persistence.accessMode`                               | Persistent Volume access mode (DEPRECATED: use `persistence.accessModes` instead)                             | `ReadWriteOnce`         |
| `persistence.size`                                     | Persistent Volume size                                                                                        | `10Gi`                  |
| `persistence.dataSource`                               | Custom PVC data source                                                                                        | `{}`                    |
| `persistence.existingClaim`                            | The name of an existing PVC to use for persistence                                                            | `""`                    |
| `persistence.selector`                                 | Selector to match an existing Persistent Volume for Kimai data PVC                                            | `{}`                    |
| `persistence.annotations`                              | Persistent Volume Claim annotations                                                                           | `{}`                    |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup`               | `false`                 |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                                  | `docker.io`             |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                                | `bitnami/bitnami-shell` |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                                      | `11-debian-11-r112`     |
| `volumePermissions.image.digest`                       | Bitnami Shell image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                    |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                               | `IfNotPresent`          |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                              | `[]`                    |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                                   | `{}`                    |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                                | `{}`                    |
| `volumePermissions.containerSecurityContext.runAsUser` | User ID for the init container                                                                                | `0`                     |


### Other Parameters

| Name                                          | Description                                                            | Value   |
|-----------------------------------------------|------------------------------------------------------------------------|---------|
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Kimai pod                        | `false` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                 | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `true`  |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |
| `pdb.create`                                  | Enable a Pod Disruption Budget creation                                | `false` |
| `pdb.minAvailable`                            | Minimum number/percentage of pods that should remain scheduled         | `1`     |
| `pdb.maxUnavailable`                          | Maximum number/percentage of pods that may be made unavailable         | `""`    |
| `autoscaling.enabled`                         | Enable Horizontal POD autoscaling for Kimai                            | `false` |
| `autoscaling.minReplicas`                     | Minimum number of Kimai replicas                                       | `1`     |
| `autoscaling.maxReplicas`                     | Maximum number of Kimai replicas                                       | `11`    |
| `autoscaling.targetCPU`                       | Target CPU utilization percentage                                      | `50`    |
| `autoscaling.targetMemory`                    | Target Memory utilization percentage                                   | `50`    |

### NetworkPolicy parameters

| Name                                                          | Description                                                                                                                  | Value   |
|---------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|---------|
| `networkPolicy.enabled`                                       | Enable network policies                                                                                                      | `false` |
| `networkPolicy.metrics.enabled`                               | Enable network policy for metrics (prometheus)                                                                               | `false` |
| `networkPolicy.metrics.namespaceSelector`                     | Monitoring namespace selector labels. These labels will be used to identify the prometheus' namespace.                       | `{}`    |
| `networkPolicy.metrics.podSelector`                           | Monitoring pod selector labels. These labels will be used to identify the Prometheus pods.                                   | `{}`    |
| `networkPolicy.ingress.enabled`                               | Enable network policy for Ingress Proxies                                                                                    | `false` |
| `networkPolicy.ingress.namespaceSelector`                     | Ingress Proxy namespace selector labels. These labels will be used to identify the Ingress Proxy's namespace.                | `{}`    |
| `networkPolicy.ingress.podSelector`                           | Ingress Proxy pods selector labels. These labels will be used to identify the Ingress Proxy pods.                            | `{}`    |
| `networkPolicy.ingressRules.backendOnlyAccessibleByFrontend`  | Enable ingress rule that makes the backend (mariadb) only accessible by testlink's pods.                                     | `false` |
| `networkPolicy.ingressRules.customBackendSelector`            | Backend selector labels. These labels will be used to identify the backend pods.                                             | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.enabled`           | Enable ingress rule that makes testlink only accessible from a particular origin                                             | `false` |
| `networkPolicy.ingressRules.accessOnlyFrom.namespaceSelector` | Namespace selector label that is allowed to access testlink. This label will be used to identified the allowed namespace(s). | `{}`    |
| `networkPolicy.ingressRules.accessOnlyFrom.podSelector`       | Pods selector label that is allowed to access testlink. This label will be used to identified the allowed pod(s).            | `{}`    |
| `networkPolicy.ingressRules.customRules`                      | Custom network policy ingress rule                                                                                           | `{}`    |
| `networkPolicy.egressRules.denyConnectionsToExternal`         | Enable egress rule that denies outgoing traffic outside the cluster, except for DNS (port 53).                               | `false` |
| `networkPolicy.egressRules.customRules`                       | Custom network policy rule                                                                                                   | `{}`    |


### Database Parameters

| Name                                       | Description                                                                       | Value                 |
|--------------------------------------------|-----------------------------------------------------------------------------------|-----------------------|
| `mariadb.enabled`                          | Deploy a MariaDB server to satisfy the applications database requirements         | `true`                |
| `mariadb.architecture`                     | MariaDB architecture. Allowed values: `standalone` or `replication`               | `standalone`          |
| `mariadb.auth.rootPassword`                | MariaDB root password                                                             | `"kimaiR00tPassw0rd"` |
| `mariadb.auth.database`                    | MariaDB custom database                                                           | `kimai`               |
| `mariadb.auth.username`                    | MariaDB custom user name                                                          | `kimai`               |
| `mariadb.auth.password`                    | MariaDB custom user password                                                      | `"kimai"`             |
| `mariadb.primary.persistence.enabled`      | Enable persistence on MariaDB using PVC(s)                                        | `true`                |
| `mariadb.primary.persistence.storageClass` | Persistent Volume storage class                                                   | `""`                  |
| `mariadb.primary.persistence.accessModes`  | Persistent Volume access modes                                                    | `[]`                  |
| `mariadb.primary.persistence.size`         | Persistent Volume size                                                            | `8Gi`                 |
| `externalDatabase.host`                    | External Database server host                                                     | `localhost`           |
| `externalDatabase.port`                    | External Database server port                                                     | `3306`                |
| `externalDatabase.user`                    | External Database username                                                        | `kimai`               |
| `externalDatabase.password`                | External Database user password                                                   | `"kimai"`             |
| `externalDatabase.database`                | External Database database name                                                   | `kimai`               |
| `externalDatabase.existingSecret`          | The name of an existing secret with database credentials. Evaluated as a template | `""`                  |

### Redis&reg; parameters

| Name                                      | Description                                                                                                                                                                                                              | Value        |
|-------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------|
| `redis.enabled`                           | Switch to enable or disable the Redis&reg; helm                                                                                                                                                                          | `false`      |
| `redis.auth.enabled`                      | Enable password authentication                                                                                                                                                                                           | `false`      |
| `redis.auth.password`                     | Redis&reg; password                                                                                                                                                                                                      | `""`         |
| `redis.auth.existingSecret`               | The name of an existing secret with Redis&reg; credentials                                                                                                                                                               | `""`         |
| `redis.architecture`                      | Redis&reg; architecture. Allowed values: `standalone` or `replication`                                                                                                                                                   | `standalone` |
| `redis.sentinel.enabled`                  | Use Redis&reg; Sentinel on Redis&reg; pods.                                                                                                                                                                              | `false`      |
| `redis.sentinel.masterSet`                | Master set name                                                                                                                                                                                                          | `mymaster`   |
| `redis.sentinel.service.ports.sentinel`   | Redis&reg; service port for Redis&reg; Sentinel                                                                                                                                                                          | `26379`      |
| `redis.master.resourcesPreset`            | Set container resources according to one common preset (allowed values: none, nano, small, medium, large, xlarge, 2xlarge). This is ignored if master.resources is set (master.resources is recommended for production). | `nano`       |
| `redis.master.resources`                  | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                        | `{}`         |
| `externalRedis.host`                      | Redis&reg; host                                                                                                                                                                                                          | `localhost`  |
| `externalRedis.port`                      | Redis&reg; port number                                                                                                                                                                                                   | `6379`       |
| `externalRedis.password`                  | Redis&reg; password                                                                                                                                                                                                      | `""`         |
| `externalRedis.coreDatabaseIndex`         | Index for core database                                                                                                                                                                                                  | `0`          |
| `externalRedis.jobserviceDatabaseIndex`   | Index for jobservice database                                                                                                                                                                                            | `1`          |
| `externalRedis.registryDatabaseIndex`     | Index for registry database                                                                                                                                                                                              | `2`          |
| `externalRedis.trivyAdapterDatabaseIndex` | Index for trivy adapter database                                                                                                                                                                                         | `5`          |
| `externalRedis.sentinel.enabled`          | If external redis with sentinal is used, set it to `true`                                                                                                                                                                | `false`      |
| `externalRedis.sentinel.masterSet`        | Name of sentinel masterSet if sentinel is used                                                                                                                                                                           | `mymaster`   |
| `externalRedis.sentinel.hosts`            | Sentinel hosts and ports in the format                                                                                                                                                                                   | `""`         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set kimaiAdminEmail=admin@example.com \
  --set kimaiAdminPassword=password \
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

### A note about database credentials
https://symfony.com/doc/6.4/doctrine.html#configuring-the-database

> If the username, password, host or database name contain any character considered special in a URI (such as : / ? # [ ] @ ! $ & ' ( ) * + , ; =), you must encode them. See RFC 3986 for the full list of reserved characters or use the urlencode function to encode them. In this case you need to remove the resolve: prefix in config/packages/doctrine.yaml to avoid errors: url: '%env(DATABASE_URL)%'

The underlying `dbtest.php` script does not support this, so **don't use special characters**

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

### Persistence
The [Kimai2](https://github.com/tobybatch/kimai2) image stores the Kimai data at the /opt/kimai/var/data path of the container. Persistent Volume Claims are used to keep the data across deployments.

### Plugins
You have 2 options to add plugins to your Kimai installation

1. Create a custom docker image and add the plugins under `/opt/kimai/var/plugins`

2. Add a volume map and upload the plugin.

   Here an example using the default volume 
```yaml
persistence:
   enabled: true
extraVolumeMounts:
    - mountPath: /opt/kimai/var/plugins
      name: kimai-data
      subPath: plugins
```

### Using redis for cache
Set `kimaiRedisCache` to `true` and provide your redis connection default. You can also use the redis provided with this chart by setting `redis.enabled` to `true`

## Upgrading

### To 4.0.0

Per default only `/opt/kimai/var/data` are present in the persistence volume. You can use `extraVolumeMounts` to add additional directories to the volume

### To 3.0.0

This major release renames several values in this chart and adds missing features. It's based on the [bitnami wordpress chart](https://github.com/bitnami/charts/tree/main/bitnami/wordpress)

It also bumps the app version to 2.x

### To 2.0.0

This major release bumps default MariaDB version to 10.6. Follow the [official instructions](https://mariadb.com/kb/en/upgrading-from-mariadb-105-to-mariadb-106/) from upgrading between 10.5 and 10.6.

No major issues are expected during the upgrade.
