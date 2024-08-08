{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kimai.mariadb.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mariadb" "chartValues" .Values.mariadb "context" $) -}}
{{- end -}}

{{/*
Return the proper WordPress image name
*/}}
{{- define "kimai.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "kimai.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kimai.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "kimai.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Return the kimai Secret Name
*/}}
{{- define "kimai.secretName" -}}
{{- if .Values.existingSecret }}
    {{- printf "%s" .Values.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Kimai configuration secret
*/}}
{{- define "kimai.configSecretName" -}}
{{- if .Values.configurationFromSecret.secretName -}}
    {{- printf "%s" (tpl .Values.configurationFromSecret.secretName $) -}}
{{- else -}}
    {{- printf "%s-config" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Hostname
*/}}
{{- define "kimai.databaseHost" -}}
{{- if .Values.mariadb.enabled }}
    {{- if eq .Values.mariadb.architecture "replication" }}
        {{- printf "%s-primary" (include "kimai.mariadb.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "kimai.mariadb.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}
{{/*

{{/*
Return the Database Port
*/}}
{{- define "kimai.databasePort" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database ServerVersion
*/}}
{{- define "kimai.databaseServerVersion" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" (regexReplaceAll "-.*$" .Values.mariadb.image.tag "") -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Name
*/}}
{{- define "kimai.databaseName" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database User
*/}}
{{- define "kimai.databaseUser" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Password
*/}}
{{- define "kimai.databasePassword" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.password -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.password -}}
{{- end -}}
{{- end -}}

{{/*
Create the Database URL. For the time being, this supports only an integrated MySQL
*/}}
{{- define "kimai.databaseUrl" -}}
mysql://{{ include "kimai.databaseUser" . }}:{{ include "kimai.databasePassword" . }}@{{ include "kimai.databaseHost" . }}/{{ include "kimai.databaseName" . }}?charset=utf8&serverVersion={{ include "kimai.databaseServerVersion" . }}
{{- end }}

{{/*
Create a default fully qualified app name
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kimai.redis.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "redis" "chartValues" .Values.redis "context" $) -}}
{{- end -}}

{{- define "kimai.redis.host" -}}
{{- ternary (ternary (printf "%s-headless" (include "kimai.redis.fullname" .)) (printf "%s-master" (include "kimai.redis.fullname" .)) .Values.redis.sentinel.enabled) (ternary (printf "%s" .Values.externalRedis.sentinel.hosts) .Values.externalRedis.host .Values.externalRedis.sentinel.enabled) .Values.redis.enabled -}}
{{- end -}}

{{- define "kimai.redis.port" -}}
{{- ternary (ternary (int64 .Values.redis.sentinel.service.ports.sentinel) "6379" .Values.redis.sentinel.enabled) .Values.externalRedis.port .Values.redis.enabled -}}
{{- end -}}

{{- define "kimai.redis.sentinel.masterSet" -}}
{{- ternary (ternary (printf "%s" .Values.redis.sentinel.masterSet) ("") .Values.redis.sentinel.enabled) (ternary (printf "%s" .Values.externalRedis.sentinel.masterSet) ("") .Values.externalRedis.sentinel.enabled) .Values.redis.enabled -}}
{{- end -}}

{{- define "kimai.redis.coreDatabaseIndex" -}}
{{- ternary "0" .Values.externalRedis.coreDatabaseIndex .Values.redis.enabled -}}
{{- end -}}

{{- define "kimai.redis.jobserviceDatabaseIndex" -}}
{{- ternary "1" .Values.externalRedis.jobserviceDatabaseIndex .Values.redis.enabled -}}
{{- end -}}

{{- define "kimai.redis.registryDatabaseIndex" -}}
{{- ternary "2" .Values.externalRedis.registryDatabaseIndex .Values.redis.enabled -}}
{{- end -}}

{{- define "kimai.redis.trivyAdapterDatabaseIndex" -}}
{{- ternary "5" .Values.externalRedis.trivyAdapterDatabaseIndex .Values.redis.enabled -}}
{{- end -}}

{{/*
Return whether Redis&reg; uses password authentication or not
*/}}
{{- define "kimai.redis.auth.enabled" -}}
{{- if or .Values.redis.auth.enabled (and (not .Values.redis.enabled) .Values.externalRedis.password) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{- define "kimai.redis.rawPassword" -}}
  {{- if and (not .Values.redis.enabled) .Values.externalRedis.password -}}
    {{- .Values.externalRedis.password -}}
  {{- end -}}
  {{- if and .Values.redis.enabled .Values.redis.auth.password .Values.redis.auth.enabled -}}
    {{- .Values.redis.auth.password -}}
  {{- end -}}
{{- end -}}

{{- define "kimai.redis.escapedRawPassword" -}}
  {{- if (include "kimai.redis.rawPassword" . ) -}}
    {{- include "kimai.redis.rawPassword" . | urlquery | replace "+" "%20" -}}
  {{- end -}}
{{- end -}}

{{/*the username redis is used for a placeholder as no username needed in redis*/}}
{{- define "kimai.redisUrl" -}}
  {{- if and (eq .Values.externalRedis.sentinel.enabled false) (eq .Values.redis.sentinel.enabled false) -}}
    {{- if (include "kimai.redis.escapedRawPassword" . ) -}}
      {{- printf "redis://default:%s@%s:%s/%s" (include "kimai.redis.escapedRawPassword" . ) (include "kimai.redis.host" . ) (include "kimai.redis.port" . ) (include "kimai.redis.jobserviceDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis://%s:%s/%s" (include "kimai.redis.host" .) (include "kimai.redis.port" .) (include "kimai.redis.jobserviceDatabaseIndex" .) -}}
    {{- end -}}
  {{- else -}}
    {{- if (include "kimai.redis.escapedRawPassword" . ) -}}
      {{- printf "redis+sentinel://default:%s@%s:%s/%s/%s" (include "kimai.redis.escapedRawPassword" . ) (include "kimai.redis.host" . ) (include "kimai.redis.port" . ) (include "kimai.redis.sentinel.masterSet" . ) (include "kimai.redis.jobserviceDatabaseIndex" . ) -}}
    {{- else -}}
      {{- printf "redis+sentinel://%s:%s/%s/%s" (include "kimai.redis.host" . ) (include "kimai.redis.port" . ) (include "kimai.redis.sentinel.masterSet" . ) (include "kimai.redis.jobserviceDatabaseIndex" . ) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
