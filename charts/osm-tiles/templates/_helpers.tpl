{{/*
Expand the name of the chart.
*/}}
{{- define "osm-tiles.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "osm-tiles.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "osm-tiles.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "osm-tiles.labels" -}}
helm.sh/chart: {{ include "osm-tiles.chart" . }}
{{ include "osm-tiles.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "osm-tiles.selectorLabels" -}}
app.kubernetes.io/name: {{ include "osm-tiles.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "osm-tiles.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "osm-tiles.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "osm-tiles.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "osm-tiles.database" -}}
{{- ternary (include "osm-tiles.postgresql.fullname" .) .Values.externalDatabase.host .Values.postgresql.enabled | quote -}}
{{- end -}}




{{- define "osm-tiles.databaseHost" -}}
{{- printf "%s" (include "osm-tiles.postgresql.fullname" .) -}}
{{- end -}}


{{- define "osm-tiles.databasePort" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "5432" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}


{{- define "osm-tiles.databaseName" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.postgresqlDatabase -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}


{{- define "osm-tiles.databaseUser" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "postgres" -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}


{{- define "osm-tiles.databasePassword" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.postgresqlPassword -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.password -}}
{{- end -}}
{{- end -}}

{{- define "osm-tiles.databaseDSN" -}}
postgresql://{{ include "osm-tiles.databaseUser" . }}:{{ include "osm-tiles.databasePassword" . }}@{{ include "osm-tiles.databaseHost" . }}:{{ include "osm-tiles.databasePort" . }}/{{ include "osm-tiles.databaseName" . }}
{{- end }}