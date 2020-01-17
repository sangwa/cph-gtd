{{/* vim: set filetype=mustache: */}}

{{/* This is mostly a copy paste from common public charts, adapted for the case... */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "gtd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gtd.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gtd.chart" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a set of labels.
*/}}
{{- define "gtd.labels" -}}
app: {{ template "gtd.fullname" . }}
chart: {{ template "gtd.chart" . }}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
{{- end -}}

{{/*
Create a fully qualified configmap name.
*/}}
{{- define "gtd.configmap.fullname" -}}
{{- printf "%s-%s" .Release.Name "config" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified secret name.
*/}}
{{- define "gtd.secret.fullname" -}}
{{- printf "%s-%s" .Release.Name "secret" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
