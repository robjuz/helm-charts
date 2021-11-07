{{/*
Expand the name of the chart.
*/}}
{{- define "futtertrog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "futtertrog.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "futtertrog.mariadb.fullname" -}}
{{- printf "%s-mariadb" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "futtertrog.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "futtertrog.labels" -}}
helm.sh/chart: {{ include "futtertrog.chart" . }}
{{ include "futtertrog.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "futtertrog.selectorLabels" -}}
app.kubernetes.io/name: {{ include "futtertrog.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "futtertrog.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "futtertrog.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the MariaDB Hostname
*/}}
{{- define "futtertrog.databaseHost" -}}
{{- if .Values.mariadb.enabled }}
    {{- if eq .Values.mariadb.architecture "replication" }}
        {{- printf "%s-primary" (include "futtertrog.mariadb.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "futtertrog.mariadb.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "futtertrog.databasePort" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Database Name
*/}}
{{- define "futtertrog.databaseName" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB User
*/}}
{{- define "futtertrog.databaseUser" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Password
*/}}
{{- define "futtertrog.databasePassword" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.password -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.password -}}
{{- end -}}
{{- end -}}

{{/*
Create the database URL. For the time being, this supports only an integrated MySQL
*/}}
{{- define "futtertrog.databaseUrl" -}}
mysql://{{ include "futtertrog.databaseUser" . }}:{{ include "futtertrog.databasePassword" . }}@{{ include "futtertrog.databaseHost" . }}/{{ include "futtertrog.databaseName" . }}
{{- end }}

{{/*
Get a hostname from URL
*/}}
{{- define "hostname" -}}
{{- . | trimPrefix "http://" |  trimPrefix "https://" | trimSuffix "/" | trim | quote -}}
{{- end -}}