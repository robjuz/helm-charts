
{{/*
Create the name of the service account to use
*/}}
{{- define "osm-tiles.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Fully qualified app name for Pgpool
*/}}
{{- define "osm-tiles.postgresql.pgpool" -}}
{{- if .Values.postgresql.fullnameOverride -}}
{{- printf "%s-pgpool" .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s-pgpool" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "osm-tiles.databaseHost" -}}
{{- ternary (include "osm-tiles.postgresql.pgpool" .) .Values.externalDatabase.host .Values.postgresql.enabled -}}
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
    {{- printf "%s" .Values.postgresql.postgresql.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}


{{- define "osm-tiles.databaseUser" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf .Values.postgresql.postgresql.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}


{{- define "osm-tiles.databasePassword" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "%s" .Values.postgresql.postgresql.password -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.password -}}
{{- end -}}
{{- end -}}

{{- define "osm-tiles.databaseDSN" -}}
postgresql://{{ include "osm-tiles.databaseUser" . }}:{{ include "osm-tiles.databasePassword" . }}@{{ include "osm-tiles.databaseHost" . }}:{{ include "osm-tiles.databasePort" . }}/{{ include "osm-tiles.databaseName" . }}
{{- end }}