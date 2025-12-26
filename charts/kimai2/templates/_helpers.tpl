{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kimai.mariadb.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mariadb" "chartValues" .Values.mariadb "context" $) -}}
{{- end -}}

{{/*
Return the proper Kimai image name
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
    {{- .Values.externalDatabase.serverVersion -}}
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