# Nominatim

[Nominatim](https://Nominatim.org/) is a tool (an API) to search OSM data by name and address and to generate synthetic
addresses of OSM points (reverse geocoding).

## TL;DR

```console
helm repo add robjuz https://robjuz.github.io/helm-charts/
helm install nominatim robjuz/nominatim
```

## Introduction

This chart bootstraps a [Nominatim](https://nominatim.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster
using the [Helm](https://helm.sh) package manager.

It also packages a [Bitnami PostgreSQL chart](https://github.com/bitnami/charts/tree/master/bitnami/postgresql) 
which is required for bootstrapping a PostgreSQL deployment for the database requirements of the Nominatim application.

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

Set```initJob.enabled: true```

During the initialization, all required data are downloaded and the database is build.
To improve the import speed you can set additional PostgreSQL params

```yaml
initJob:
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

You need to set ```initJob.enabled: false```

You also should remove the ```postgresql.primary.extendedConfiguration```

```yaml
initJob:
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

## Removing persisted data
For a total uninstallation of nomination, a data removal is necessary. To do so, first of all, you need to search for the right persistence volume. To indetify it, you need to type de command below, and search for a volume containing the helm release name.

```console
kubectl get pvc
```

You'll receive an output similar to:

| NAME                        | STATUS | VOLUME                                   | CAPACITY | ACCESS MODES | STORAGECLASS | AGE  |
|-----------------------------|--------|------------------------------------------|----------|--------------|--------------|------|
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

### Nominatim Image parameters

| Name                | Description                                                                                               | Value                |
|---------------------|-----------------------------------------------------------------------------------------------------------|----------------------|
| `image.registry`    | Nominatim image registry                                                                                  | `docker.io`          |
| `image.repository`  | Nominatim image repository                                                                                | `mediagis/nominatim` |
| `image.tag`         | Nominatim image tag (immutable tags are recommended)                                                      | `4.3`                |
| `image.digest`      | Nominatim image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                 |
| `image.pullPolicy`  | Nominatim image pull policy                                                                               | `IfNotPresent`       |
| `image.pullSecrets` | Nominatim image pull secrets                                                                              | `[]`                 |
| `image.debug`       | Specify if debug values should be set                                                                     |                      |

### Nominatim Initialisation Configuration parameters

| Name                        | Description                                                 | Value                                                                 |
|-----------------------------|-------------------------------------------------------------|-----------------------------------------------------------------------|
| `initJob.enabled`           | enable/disable init job                                     | `false `                                                              |
| `initJob.pbfUrl`            | URL of the pbf file to import                               | `https://download.geofabrik.de/europe/germany/sachsen-latest.osm.pbf` |
| `initJob.importWikipedia`   | If additional Wikipedia/Wikidata rankings should be importe | `false`                                                               |
| `initJob.wikipediaUrl`      | Wikipedia/Wikidata rankings file URL                        | `https://nominatim.org/data/wikimedia-importance.sql.gz`              |
| `initJob.importGB_Postcode` | If external GB postcodes should be imported                 | `false`                                                               |
| `initJob.importUS_Postcode` | If external US postcodes should be imported                 | `false`                                                               |
| `initJob.importStyle`       | Nominatim import style                                      | `full`                                                                |
| `initJob.customStyleUrl`    | Custom import style file URL                                | `nil`                                                                 |
| `initJob.threads`           | The number of thread used by the import                     | `16`                                                                  |


### Nominatim Initialisation Deployment parameters

| Name                                                        | Description                                                                                                                                                                                                       | Value             |
|-------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|
| `initJob.resources`                                         | Define resources requests and limits for the init container                                                                                                                                                       | `{}`              |
| `initJob.persistence.enabled`                               | Enable persistence using Persistent Volume Claims                                                                                                                                                                 | `false`           |
| `initJob.persistence.storageClass`                          | Persistent Volume storage class                                                                                                                                                                                   | `nil`             |
| `initJob.persistence.accessModes`                           | Persistent Volume access modes                                                                                                                                                                                    | `[ReadWriteOnce]` |
| `initJob.persistence.size`                                  | Persistent Volume size                                                                                                                                                                                            | `100Gi`           |
| `initJob.persistence.dataSource`                            | Custom PVC data source                                                                                                                                                                                            | `{}`              |
| `initJob.persistence.existingClaim`                         | The name of an existing PVC to use for flatnode                                                                                                                                                                   | `nil`             |
| `initJob.persistence.selector`                              | Selector to match an existing Persistent Volume for Nominatim data PVC                                                                                                                                            | `{}`              |
| `initJob.persistence.annotations`                           | Persistent Volume Claim annotations                                                                                                                                                                               | `{}`              |
| `initJob.resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`           |
| `initJob.resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`              |
| `updates.podSecurityContext.enabled`                        | Enabled Nominatim pods' Security Context                                                                                                                                                                          | `true`            |
| `updates.podSecurityContext.fsGroup`                        | Set Nominatim pod's Security Context fsGroup                                                                                                                                                                      | `101`             |
| `updates.podSecurityContext.seccompProfile.type`            | Set Nominatim container's Security Context seccomp profile                                                                                                                                                        | `RuntimeDefault`  |
| `updates.containerSecurityContext.enabled`                  | Enabled Nominatim containers' Security Context                                                                                                                                                                    | `false`           |
| `updates.containerSecurityContext.runAsUser`                | Set Nominatim container's Security Context runAsUser                                                                                                                                                              | `1001`            |
| `updates.containerSecurityContext.runAsNonRoot`             | Set Nominatim container's Security Context runAsNonRoot                                                                                                                                                           | `true`            |
| `updates.containerSecurityContext.allowPrivilegeEscalation` | Set Nominatim container's privilege escalation                                                                                                                                                                    | `false`           |
| `updates.containerSecurityContext.capabilities.drop`        | Set Nominatim container's Security Context runAsNonRoot                                                                                                                                                           | `["ALL"]`         |

### Nominatim Updates Configuration parameters
| Name                         | Description                                                              | Value                                                           |
|------------------------------|--------------------------------------------------------------------------|-----------------------------------------------------------------|
| `updates.enabled`            | enable/disable replication                                               | `false `                                                        |
| `updates.replicationUrl`     | URL with update information                                              | `https://download.geofabrik.de/europe/germany/sachsen-updates/` |
| `updates.extraEnvVars`       | Array with extra environment variables to add to the Nominatim container | `[]`                                                            |
| `updates.extraEnvVarsCM`     | Name of existing ConfigMap containing extra env vars                     | `""`                                                            |
| `updates.extraEnvVarsSecret` | Name of existing Secret containing extra env vars                        | `""`                                                            |

### Nominatim Updates Deployment parameters

| Name                                                        | Description                                                                                                              | Value                                                           |
|-------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------|
| `updates.resources`                                         | Define resources requests and limits for the update job                                                                  | `{}`                                                            |
| `updates.podLabels`                                         | Extra labels for Nominatim Updates pods                                                                                  | `{}`                                                            |
| `updates.podAnnotations`                                    | Annotations for Nominatim Updates pods                                                                                   | `{}`                                                            |
| `updates.podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `hard`                                                          |
| `updates.podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `""`                                                            |
| `updates.nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`                                                            |
| `updates.nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                    | `""`                                                            |
| `updates.nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                 | `[]`                                                            |
| `updates.affinity`                                          | Affinity for pod assignment                                                                                              | `{}`                                                            |
| `updates.nodeSelector`                                      | Node labels for pod assignment                                                                                           | `{}`                                                            |
| `updates.tolerations`                                       | Tolerations for pod assignment                                                                                           | `[]`                                                            |
| `updates.schedulerName`                                     | Alternate scheduler                                                                                                      | `""`                                                            |
| `updates.terminationGracePeriodSeconds`                     | In seconds, time given to the Nominatim pod to terminate gracefully                                                      | `""`                                                            |
| `updates.topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`                                                            |
| `updates.priorityClassName`                                 | Name of the existing priority class to be used by Nominatim pods, priority class needs to be created beforehand          | `""`                                                            |
| `updates.podSecurityContext.enabled`                        | Enabled Nominatim pods' Security Context                                                                                 | `false`                                                         |
| `updates.podSecurityContext.fsGroup`                        | Set Nominatim pod's Security Context fsGroup                                                                             | `1001`                                                          |
| `updates.podSecurityContext.seccompProfile.type`            | Set Nominatim container's Security Context seccomp profile                                                               | `RuntimeDefault`                                                |
| `updates.containerSecurityContext.enabled`                  | Enabled Nominatim containers' Security Context                                                                           | `false`                                                         |
| `updates.containerSecurityContext.runAsUser`                | Set Nominatim container's Security Context runAsUser                                                                     | `1001`                                                          |
| `updates.containerSecurityContext.runAsNonRoot`             | Set Nominatim container's Security Context runAsNonRoot                                                                  | `true`                                                          |
| `updates.containerSecurityContext.allowPrivilegeEscalation` | Set Nominatim container's privilege escalation                                                                           | `false`                                                         |
| `updates.containerSecurityContext.capabilities.drop`        | Set Nominatim container's Security Context runAsNonRoot                                                                  | `["ALL"]`                                                       |

### Nominatim configuration parameters
| Name                 | Description                                                              | Value |
|----------------------|--------------------------------------------------------------------------|-------|
| `command`            | Override default container command (useful when using custom images)     | `[]`  |
| `args`               | Override default container args (useful when using custom images)        | `[]`  |
| `extraEnvVars`       | Array with extra environment variables to add to the Nominatim container | `[]`  |
| `extraEnvVarsCM`     | Name of existing ConfigMap containing extra env vars                     | `""`  |
| `extraEnvVarsSecret` | Name of existing Secret containing extra env vars                        | `""`  |

### Nominatim deployment parameters

| Name                                                | Description                                                                                                                                                                                                       | Value            |
|-----------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| `replicaCount`                                      | Number of Nominatim replicas to deploy                                                                                                                                                                            | `1`              |
| `updateStrategy.type`                               | Nominatim deployment strategy type                                                                                                                                                                                | `RollingUpdate`  |
| `schedulerName`                                     | Alternate scheduler                                                                                                                                                                                               | `""`             |
| `terminationGracePeriodSeconds`                     | In seconds, time given to the Nominatim pod to terminate gracefully                                                                                                                                               | `""`             |
| `topologySpreadConstraints`                         | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template                                                                                          | `[]`             |
| `priorityClassName`                                 | Name of the existing priority class to be used by Nominatim pods, priority class needs to be created beforehand                                                                                                   | `""`             |
| `hostAliases`                                       | Nominatim pod host aliases                                                                                                                                                                                        | `[]`             |
| `extraVolumes`                                      | Optionally specify extra list of additional volumes for Nominatim pods                                                                                                                                            | `[]`             |
| `extraVolumeMounts`                                 | Optionally specify extra list of additional volumeMounts for Nominatim container(s)                                                                                                                               | `[]`             |
| `sidecars`                                          | Add additional sidecar containers to the Nominatim pod                                                                                                                                                            | `[]`             |
| `initContainers`                                    | Add additional init containers to the Nominatim pods                                                                                                                                                              | `[]`             |
| `podLabels`                                         | Extra labels for Nominatim pods                                                                                                                                                                                   | `{}`             |
| `podAnnotations`                                    | Annotations for Nominatim pods                                                                                                                                                                                    | `{}`             |
| `podAffinityPreset`                                 | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                               | `""`             |
| `podAntiAffinityPreset`                             | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                          | `soft`           |
| `nodeAffinityPreset.type`                           | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                                                                                                         | `""`             |
| `nodeAffinityPreset.key`                            | Node label key to match. Ignored if `affinity` is set                                                                                                                                                             | `""`             |
| `nodeAffinityPreset.values`                         | Node label values to match. Ignored if `affinity` is set                                                                                                                                                          | `[]`             |
| `affinity`                                          | Affinity for pod assignment                                                                                                                                                                                       | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment                                                                                                                                                                                    | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment                                                                                                                                                                                    | `[]`             |
| `resourcesPreset`                                   | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if resources is set (resources is recommended for production). | `micro`          |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                                                                                                 | `{}`             | 
| `extraContainerPorts`                               | Optionally specify extra list of additional ports for Nominatim container(s)                                                                                                                                      | `[]`             |
| `podSecurityContext.enabled`                        | Enabled Nominatim pods' Security Context                                                                                                                                                                          | `false`          |
| `podSecurityContext.fsGroup`                        | Set Nominatim pod's Security Context fsGroup                                                                                                                                                                      | `1001`           |
| `podSecurityContext.seccompProfile.type`            | Set Nominatim container's Security Context seccomp profile                                                                                                                                                        | `RuntimeDefault` |
| `containerSecurityContext.enabled`                  | Enabled Nominatim containers' Security Context                                                                                                                                                                    | `false`          |
| `containerSecurityContext.runAsUser`                | Set Nominatim container's Security Context runAsUser                                                                                                                                                              | `1001`           |
| `containerSecurityContext.runAsNonRoot`             | Set Nominatim container's Security Context runAsNonRoot                                                                                                                                                           | `true`           |
| `containerSecurityContext.allowPrivilegeEscalation` | Set Nominatim container's privilege escalation                                                                                                                                                                    | `false`          |
| `containerSecurityContext.capabilities.drop`        | Set Nominatim container's Security Context runAsNonRoot                                                                                                                                                           | `["ALL"]`        |
| `livenessProbe.enabled`                             | Enable livenessProbe on Nominatim containers                                                                                                                                                                      | `true`           |
| `livenessProbe.initialDelaySeconds`                 | Initial delay seconds for livenessProbe                                                                                                                                                                           | `120`            |
| `livenessProbe.periodSeconds`                       | Period seconds for livenessProbe                                                                                                                                                                                  | `10`             |
| `livenessProbe.timeoutSeconds`                      | Timeout seconds for livenessProbe                                                                                                                                                                                 | `5`              |
| `livenessProbe.failureThreshold`                    | Failure threshold for livenessProbe                                                                                                                                                                               | `6`              |
| `livenessProbe.successThreshold`                    | Success threshold for livenessProbe                                                                                                                                                                               | `1`              |
| `readinessProbe.enabled`                            | Enable readinessProbe on Nominatim containers                                                                                                                                                                     | `true`           |
| `readinessProbe.initialDelaySeconds`                | Initial delay seconds for readinessProbe                                                                                                                                                                          | `30`             |
| `readinessProbe.periodSeconds`                      | Period seconds for readinessProbe                                                                                                                                                                                 | `10`             |
| `readinessProbe.timeoutSeconds`                     | Timeout seconds for readinessProbe                                                                                                                                                                                | `5`              |
| `readinessProbe.failureThreshold`                   | Failure threshold for readinessProbe                                                                                                                                                                              | `6`              |
| `readinessProbe.successThreshold`                   | Success threshold for readinessProbe                                                                                                                                                                              | `1`              |
| `startupProbe.enabled`                              | Enable startupProbe on Nominatim containers                                                                                                                                                                       | `false`          |
| `startupProbe.initialDelaySeconds`                  | Initial delay seconds for startupProbe                                                                                                                                                                            | `30`             |
| `startupProbe.periodSeconds`                        | Period seconds for startupProbe                                                                                                                                                                                   | `10`             |
| `startupProbe.timeoutSeconds`                       | Timeout seconds for startupProbe                                                                                                                                                                                  | `5`              |
| `startupProbe.failureThreshold`                     | Failure threshold for startupProbe                                                                                                                                                                                | `6`              |
| `startupProbe.successThreshold`                     | Success threshold for startupProbe                                                                                                                                                                                | `1`              |
| `customLivenessProbe`                               | Custom livenessProbe that overrides the default one                                                                                                                                                               | `{}`             |
| `customReadinessProbe`                              | Custom readinessProbe that overrides the default one                                                                                                                                                              | `{}`             |
| `customStartupProbe`                                | Custom startupProbe that overrides the default one                                                                                                                                                                | `{}`             |
| `lifecycleHooks`                                    | for the Nominatim container(s) to automate configuration before or after startup                                                                                                                                  | `{}`             |

### Traffic Exposure Parameters

| Name                               | Description                                                                                                                                              | Value                    |
|------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------|
| `service.type`                     | Nominatim service type                                                                                                                                   | `LoadBalancer`           |
| `service.ports.http`               | Nominatim service HTTP port                                                                                                                              | `80`                     |
| `service.httpsTargetPort`          | Target port for HTTPS                                                                                                                                    | `https`                  |
| `service.nodePorts.http`           | Node port for HTTP                                                                                                                                       | `""`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                                         | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                                              | `{}`                     |
| `service.clusterIP`                | Nominatim service Cluster IP                                                                                                                             | `""`                     |
| `service.loadBalancerIP`           | Nominatim service Load Balancer IP                                                                                                                       | `""`                     |
| `service.loadBalancerSourceRanges` | Nominatim service Load Balancer sources                                                                                                                  | `[]`                     |
| `service.externalTrafficPolicy`    | Nominatim service external traffic policy                                                                                                                | `Cluster`                |
| `service.annotations`              | Additional custom annotations for Nominatim service                                                                                                      | `{}`                     |
| `service.extraPorts`               | Extra port to expose on Nominatim service                                                                                                                | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for Nominatim                                                                                                           | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                                        | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                                            | `""`                     |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                                            | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record. The hostname is templated and thus can contain other variable references.                                           | `Nominatim.local`        |
| `ingress.path`                     | Default path for the ingress record                                                                                                                      | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations.                         | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                                            | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                                             | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record. The host names are templated and thus can contain other variable references. | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                                                    | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                                                      | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                                                       | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                                                  | `[]`                     |

### Flatnode Parameters

| Name                                                   | Description                                                                                                   | Value                   |
|--------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|-------------------------|
| `flatnode.enabled`                                     | Enable flatnode using Persistent Volume Claims                                                                | `false`                 |
| `flatnode.storageClass`                                | Persistent Volume storage class                                                                               | `nil`                   |
| `flatnode.accessModes`                                 | Persistent Volume access modes                                                                                | `[ReadWriteMany]`       |
| `flatnode.size`                                        | Persistent Volume size                                                                                        | `100Gi`                 |
| `flatnode.dataSource`                                  | Custom PVC data source                                                                                        | `{}`                    |
| `flatnode.existingClaim`                               | The name of an existing PVC to use for flatnode                                                               | `nil`                   |
| `flatnode.selector`                                    | Selector to match an existing Persistent Volume for Nominatim data PVC                                        | `{}`                    |
| `flatnode.annotations`                                 | Persistent Volume Claim annotations                                                                           | `{}`                    |
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
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Nominatim pod                    | `false` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                                 | `""`    |
| `serviceAccount.automountServiceAccountToken` | Allows auto mount of ServiceAccountToken on the serviceAccount created | `true`  |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount                   | `{}`    |
| `pdb.create`                                  | Enable a Pod Disruption Budget creation                                | `false` |
| `pdb.minAvailable`                            | Minimum number/percentage of pods that should remain scheduled         | `1`     |
| `pdb.maxUnavailable`                          | Maximum number/percentage of pods that may be made unavailable         | `""`    |
| `autoscaling.enabled`                         | Enable Horizontal POD autoscaling for Nominatim                        | `false` |
| `autoscaling.minReplicas`                     | Minimum number of Nominatim replicas                                   | `1`     |
| `autoscaling.maxReplicas`                     | Maximum number of Nominatim replicas                                   | `11`    |
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

| Name                 | Description                              | Value |
|----------------------|------------------------------------------|-------|
| `nominatim.extraEnv` | Additional environment variables to set. | `[]`  |

### Nominatim UI Parameters

| Name                              | Description                                                                                                                                     | Value           |
|-----------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|
| `nominatimUi.enabled`             | Installs and serves an instance of the Nominatim Demo UI. (Same as the one [hosted by OSM](https://nominatim.openstreetmap.org/ui/search.html)) | `true`          |
| `nominatimUi.version`             | Version of Nominatim UI to install. (See their [GitHub project](https://github.com/osm-search/nominatim-ui/) for referenc                       | `3.2.1`         |
| `nominatimUi.apacheConfiguration` | Apache Webserver configuration. You have to restart the appserver when you make changes while nominatim is running.                             | see values.yaml |
| `nominatimUi.configuration`       | Additional Nominatim configuration.                                                                                                             | see values.yaml |

## Configuration and installation details

### Flatnode support

When importing large extracts (Europe/Planet) the usage of flatnode is recommended.
Using flatnode with replication enabled requires the usage of a ReadWriteMany volume, because the flatnode file needs to
be shared within the pods.
This also applies when scaling the nominatim deployment.



### PVC For data

When importing large extracts (Europe/Planet) the data needed to be downloaded are quite big. If your server has not
enough disk space to store the data, you can use a dedicated PV for this.

### External database support

You may want to have Nominatim connect to an external database rather than installing one inside your cluster. Typical
reasons for this are to use a managed database service, or to share a common database server for all your applications.
To achieve this, the chart allows you to specify credentials for an external database with
the [`externalDatabase` parameter](#database-parameters). You should also disable the PostgreSQL installation with
the `postgresql.enabled` option. Here is an example:

```console
postgresql.enabled: false
externalDatabase.host=myexternalhost
externalDatabase.host=myexternalhost
externalDatabase.user=myuser
externalDatabase.password=mypassword
externalDatabase.database=mydatabase
externalDatabase.port=3306
```

* Make sure the database does not exist when running the init job. The nominatim tool will create a `nominatim` database
  for you
* Make sure the DB user has superuser rights. The nominatim tool will try to enable the postgis extension and will fail
  otherwise

#### Using an existing secret to connect to the database

You may want to use an existing secret to configure the connection to the database for your needs. To do so, you can use
the `externalDatabase.existingSecretDsn` and `externalDatabase.existingSecretDsnKey` parameters. The secret must contain
a key with the name specified in `externalDatabase.existingSecretDsnKey` and the value must be a valid PostgreSQL
DataSourceName. Here is an example:

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

This chart provides support for Ingress resources. If an Ingress controller, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress)
or [traefik](https://kubeapps.com/charts/stable/traefik), that Ingress controller can be used to serve Nominatim.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the
host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host.

### Custom Import Style

If none of the [default styles](https://nominatim.org/release-docs/latest/admin/Import/#filtering-imported-data)
satisfies your needs, you can provide your [customized style file](https://nominatim.org/release-docs/latest/customize/Import-Styles/) by setting the `initJob.customStyleUrl` value.

Make sure the file is publicly available for init job to download it. [Example](https://raw.githubusercontent.com/osm-search/Nominatim/master/settings/import-street.style)

### TLS secrets

The chart also facilitates the creation of TLS secrets for use with the Ingress controller, with different options for
certificate management.

## Upgrading

### To 4.0.0

This major release renames several values in this chart and adds missing features.

It also bumps default PostgreSQL to 16.2.0
