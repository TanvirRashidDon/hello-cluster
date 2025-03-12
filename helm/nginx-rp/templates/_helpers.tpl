{{/*
Create universal label for the release
*/}}
{{- define "common.labels" -}}
app: {{ .Release.Name }}
{{- end }}

{{/*
Create labels for the application server
*/}}
{{- define "common.app-labels" -}}
app: {{ .Release.Name }}
name: {{ .Values.app.name }}-pod
{{- end }}


{{/*
Create labels for the reverse proxy
*/}}
{{- define "common.rp-labels" -}}
app: {{ .Release.Name }}
name: {{ .Values.rp.name }}-pod
{{- end }}


{{/*
Define name for configmap for rp configuration
*/}}
{{- define "rp.configmap.name" -}}
{{ .Release.Name }}-{{ .Values.rp.name }}-config
{{- end }}

{{/*
Define name for config volume
*/}}
{{- define "rp.config.volume" -}}
{{ .Release.Name }}-{{ .Values.rp.name }}-config-volume
{{- end }}


{{/*
Define name for tls secret for rp
*/}}
{{- define "rp.secret.name" -}}
{{ .Release.Name }}-{{ .Values.rp.name }}-secret
{{- end }}


{{/*
Define name for secret volume
*/}}
{{- define "rp.secret.volume" -}}
{{ .Release.Name }}-{{ .Values.rp.name }}-secret-volume
{{- end }}

{{/*
Define name to allow rp to call by service name
*/}}
{{- define "app.service.name" -}}
{{ .Release.Name }}-{{ .Values.app.name }}-service
{{- end }}
