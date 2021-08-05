{{/*
Expand the name of the chart.
*/}}
{{- define "openstreetmaps-tile-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "openstreetmaps-tile-server.fullname" -}}
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
{{- define "openstreetmaps-tile-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "openstreetmaps-tile-server.labels" -}}
helm.sh/chart: {{ include "openstreetmaps-tile-server.chart" . }}
{{ include "openstreetmaps-tile-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "openstreetmaps-tile-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openstreetmaps-tile-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "openstreetmaps-tile-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "openstreetmaps-tile-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "openstreetmaps-tile-server.postgresql.fullname" -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "openstreetmaps-tile-server.database" -}}
{{- ternary (include "openstreetmaps-tile-server.postgresql.fullname" .) .Values.externalDatabase.host .Values.postgresql.enabled | quote -}}
{{- end -}}




{{- define "openstreetmaps-tile-server.databaseHost" -}}
{{- printf "%s" (include "openstreetmaps-tile-server.postgresql.fullname" .) -}}
{{- end -}}


{{- define "openstreetmaps-tile-server.databasePort" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "5432" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}


{{- define "openstreetmaps-tile-server.databaseName" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}


{{- define "openstreetmaps-tile-server.databaseUser" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "postgres" -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}


{{- define "openstreetmaps-tile-server.databasePassword" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.postgresqlPassword -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.password -}}
{{- end -}}
{{- end -}}

{{/*
Create the database URL. For the time being, this supports only an integrated MySQL
*/}}
{{- define "openstreetmaps-tile-server.databaseUrl" -}}
pgsql:host={{ include "openstreetmaps-tile-server.databaseHost" . }};port={{ include "openstreetmaps-tile-server.databasePort" . }};user={{ include "openstreetmaps-tile-server.databaseUser" . }};password={{ include "openstreetmaps-tile-server.databasePassword" . }};dbname={{ include "openstreetmaps-tile-server.databaseName" . }}
{{- end }}

{{- define "openstreetmaps-tile-server.databaseDSN" -}}
postgresql://{{ include "openstreetmaps-tile-server.databaseUser" . }}:{{ include "openstreetmaps-tile-server.databasePassword" . }}@{{ include "openstreetmaps-tile-server.databaseHost" . }}:{{ include "openstreetmaps-tile-server.databasePort" . }}
{{- end }}