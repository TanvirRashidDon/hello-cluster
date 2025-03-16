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
Define name for tls secret for rp
*/}}
{{- define "rp.secret.name" -}}
{{ .Release.Name }}-ingress-secret
{{- end }}

{{/*
Define name to allow rp to call by service name
*/}}
{{- define "app.service.name" -}}
{{ .Release.Name }}-{{ .Values.app.name }}-service
{{- end }}
