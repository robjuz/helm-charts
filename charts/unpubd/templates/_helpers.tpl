{{/*
Expand the name of the chart.
*/}}
{{- define "unpubd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "unpubd.fullname" -}}
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
{{- define "unpubd.mongodb.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "mongodb" "chartValues" .Values.mongodb "context" $) -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "unpubd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "unpubd.labels" -}}
helm.sh/chart: {{ include "unpubd.chart" . }}
{{ include "unpubd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "unpubd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "unpubd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}



{{/*
Return the MongoDB Hostname
*/}}
{{- define "unpubd.databaseHost" -}}
{{- if .Values.mongodb.enabled }}
    {{- if eq .Values.mongodb.architecture "replication" }}
        {{- printf "%s-primary" (include "unpubd.mongodb.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "unpubd.mongodb.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the MongoDB Port
*/}}
{{- define "unpubd.databasePort" -}}
{{- if .Values.mongodb.enabled }}
    {{- printf "27017" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the MongoDB Database Name
*/}}
{{- define "unpubd.databaseName" -}}
{{- if .Values.mongodb.enabled }}
    {{- printf "%s" .Values.mongodb.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MongoDB User
*/}}
{{- define "unpubd.databaseUser" -}}
{{- if .Values.mongodb.enabled }}
    {{- printf "%s" .Values.mongodb.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}
{{/*
Return the MongoDB User
*/}}
{{- define "unpubd.databaseRootUser" -}}
{{- if .Values.mongodb.enabled }}
    {{- printf "%s" .Values.mongodb.auth.rootUser -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.rootUser -}}
{{- end -}}
{{- end -}}

{{/*
Return the MongoDB Secret Name
*/}}
{{- define "unpubd.databaseSecretName" -}}
{{- if .Values.mongodb.enabled }}
    {{- if .Values.mongodb.auth.existingSecret -}}
        {{- printf "%s" .Values.mongodb.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "unpubd.mongodb.fullname" .) -}}
    {{- end -}}
{{- else if .Values.externalDatabase.existingSecret -}}
    {{- include "common.tplvalues.render" (dict "value" .Values.externalDatabase.existingSecret "context" $) -}}
{{- else -}}
    {{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}
