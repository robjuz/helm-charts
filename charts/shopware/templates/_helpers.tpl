{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "shopware.mariadb.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mariadb" "chartValues" .Values.mariadb "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "shopware.redis.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "memcached" "chartValues" .Values.redis "context" $) -}}
{{- end -}}

{{/*
Return the proper Shopware image name
*/}}
{{- define "shopware.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the metrics image)
*/}}
{{- define "shopware.metrics.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.metrics.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "shopware.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "shopware.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.metrics.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return true if a secret object should be created for Shopware configuration
*/}}
{{- define "shopware.createConfigSecret" -}}
{{- if and .Values.shopwareConfiguration (not .Values.existingShopwareConfigurationSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}


{{/*
Return the MariaDB Hostname
*/}}
{{- define "shopware.databaseHost" -}}
{{- if .Values.mariadb.enabled }}
    {{- if eq .Values.mariadb.architecture "replication" }}
        {{- printf "%s-primary" (include "shopware.mariadb.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "shopware.mariadb.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "shopware.databasePort" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Database Name
*/}}
{{- define "shopware.databaseName" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB User
*/}}
{{- define "shopware.databaseUser" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Password
*/}}
{{- define "shopware.databasePassword" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.password -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.password -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Secret Name
*/}}
{{- define "shopware.databaseSecretName" -}}
{{- if .Values.mariadb.enabled }}
    {{- if .Values.mariadb.auth.existingSecret -}}
        {{- printf "%s" .Values.mariadb.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "shopware.mariadb.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}



{{/*
Return the MariaDB URL
*/}}
{{- define "shopware.databaseUrl" -}}
mysql://{{ include "shopware.databaseUser" . }}:{{ include "shopware.databasePassword" . }}@{{ include "shopware.databaseHost" . }}/{{ include "shopware.databaseName" . }}
{{- end }}

{{/*
Return the Memcached Hostname
*/}}
{{- define "shopware.cacheHost" -}}
{{- if .Values.redis.enabled }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.clusterDomain }}
    {{- printf "%s.%s.svc.%s" (include "shopware.redis.fullname" .) $releaseNamespace $clusterDomain -}}
{{- else -}}
    {{- printf "%s" .Values.externalCache.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Memcached Port
*/}}
{{- define "shopware.cachePort" -}}
{{- if .Values.redis.enabled }}
    {{- printf "6379" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalCache.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Shopware Secret Name
*/}}
{{- define "shopware.secretName" -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return the SMTP Secret Name
*/}}
{{- define "shopware.smtpSecretName" -}}
{{- if .Values.smtpExistingSecret }}
    {{- printf "%s" .Values.smtpExistingSecret -}}
{{- else -}}
    {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "shopware.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "shopware.validateValues.htaccess" .) -}}
{{- $messages := append $messages (include "shopware.validateValues.database" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Shopware - htaccess configuration
*/}}
{{- define "shopware.validateValues.htaccess" -}}
{{- if and .Values.customHTAccessCM .Values.allowOverrideNone -}}
shopware: customHTAccessCM
    You are trying to use custom htaccess rules but Apache was configured
    to prohibit overriding directives with htaccess files. To use this feature,
    allow overriding Apache directives (--set allowOverrideNone=false).
{{- end -}}
{{- end -}}

{{/* Validate values of Shopware - Database */}}
{{- define "shopware.validateValues.database" -}}
{{- if and (not .Values.mariadb.enabled) (or (empty .Values.externalDatabase.host) (empty .Values.externalDatabase.port) (empty .Values.externalDatabase.database)) -}}
shopware: database
   You disable the MariaDB installation but you did not provide the required parameters
   to use an external database. To use an external database, please ensure you provide
   (at least) the following values:

       externalDatabase.host=DB_SERVER_HOST
       externalDatabase.database=DB_NAME
       externalDatabase.port=DB_SERVER_PORT
{{- end -}}
{{- end -}}


{{- define "shopware.randomSecret" -}}
{{- randAlphaNum 63 -}}{{- randNumeric 1 -}}
{{- end -}}