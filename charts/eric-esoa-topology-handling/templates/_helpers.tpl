{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "eric-esoa-topology-handling.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create release name used for cluster role.
*/}}
{{- define "eric-esoa-topology-handling.release.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eric-esoa-topology-handling.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create Ericsson product app.kubernetes.io info
*/}}
{{- define "eric-esoa-topology-handling.kubernetes-io-info" -}}
app.kubernetes.io/name: {{ .Chart.Name | quote }}
app.kubernetes.io/version: {{ .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}

{{/*
Create Ericsson Product Info
*/}}
{{- define "eric-esoa-topology-handling.helm-annotations" -}}
ericsson.com/product-name: "Topology Handling Application"
ericsson.com/product-number: "CXC 900 001"
ericsson.com/product-revision: {{regexReplaceAll "(.*)[+|-].*" .Chart.Version "${1}" | quote }}
{{- end}}

{{/*
Create logging info enabling it when logging path does not exist in the Values
*/}}
{{- define "eric-esoa-topology-handling.logging.enabled" -}}
{{ if hasKey (.Values.logging) "enabled" }}
    {{- print .Values.logging.enabled -}}
{{ else }}
    {{- print "true" -}}
{{ end }}
{{- end}}

{{/*
Create backup controller enabling option
*/}}
{{- define "eric-esoa-topology-handling.backup-controller.enabled" -}}
{{ if hasKey (index .Values "backup-controller") "enabled" }}
  {{- print (index .Values "backup-controller").enabled -}}
{{ else }}
  {{- print "true" -}}
{{ end }}
{{- end}}

{{/*
Create notification service enabling option
*/}}
{{- define "eric-esoa-topology-handling.notification-service.enabled" -}}
{{ if hasKey (index .Values "notification-service") "enabled" }}
  {{- print (index .Values "notification-service").enabled -}}
{{ else }}
  {{- print "false" -}}
{{ end }}
{{- end}}

{{/*
Create keycloak enabling option
*/}}
{{- define "eric-esoa-topology-handling.keycloak.enabled" -}}
{{ if hasKey (.Values.keycloak) "enabled" }}
    {{- print .Values.keycloak.enabled -}}
{{ else }}
    {{- print "true" -}}
{{ end }}
{{- end}}

{{/*
Create eric-pm-server info enabling it when eric-pm-server path does not exist in the Values
*/}}
{{- define "eric-esoa-topology-handling.eric-pm-server.enabled" -}}
{{ if hasKey (index .Values "eric-pm-server") "enabled" }}
    {{- print (index .Values "eric-pm-server").enabled -}}
{{ else }}
    {{- print "true" -}}
{{ end }}
{{- end}}

{{/*
Create image pull secrets for keycloak client
*/}}
{{- define "eric-esoa-topology-handling.keycloak-config.pullSecrets" -}}
{{- if .Values.imageCredentials.registry -}}
  {{- if .Values.imageCredentials.registry.pullSecret -}}
    {{- print .Values.imageCredentials.registry.pullSecret -}}
  {{- end -}}
  {{- else if .Values.global.registry.pullSecret -}}
    {{- print .Values.global.registry.pullSecret -}}
  {{- else if .Values.global.pullSecret -}}
    {{- print .Values.global.pullSecret -}}
  {{- end -}}
{{- end -}}

{{/*
Create image pull secrets for gas patcher
*/}}
{{- define "eric-esoa-topology-handling.gas-patcher.pullSecrets" -}}
{{- if .Values.imageCredentials.registry -}}
  {{- if .Values.imageCredentials.registry.pullSecret -}}
    {{- print .Values.imageCredentials.registry.pullSecret -}}
  {{- end -}}
  {{- else if .Values.global.registry.pullSecret -}}
    {{- print .Values.global.registry.pullSecret -}}
  {{- else if .Values.global.pullSecret -}}
    {{- print .Values.global.pullSecret -}}
  {{- end -}}
{{- end -}}

{{/*
Create keycloak-client image registry url
*/}}
{{- define "eric-esoa-topology-handling.keycloak-client.registryUrl" -}}
  {{ if index .Values "imageCredentials" "keycloak-client" "registry" "url" -}}
    {{- print (index .Values "imageCredentials" "keycloak-client" "registry" "url") -}}
  {{- else -}}
    {{- print .Values.global.registry.url -}}
  {{- end -}}
{{- end -}}

{{/*
Create gas-patcher image registry url
*/}}
{{- define "eric-esoa-topology-handling.gas-patcher.registryUrl" -}}
  {{ if index .Values "imageCredentials" "gas-patcher" "registry" "url" -}}
    {{- print (index .Values "imageCredentials" "gas-patcher" "registry" "url") -}}
  {{- else -}}
    {{- print .Values.global.registry.url -}}
  {{- end -}}
{{- end -}}

{{/*
Define urls for protected logging resource
*/}}
{{- define "eric-esoa-topology-handling.logging.rbac-resources" -}}
  {{- if index .Values "rbac" "eric-data-visualizer-kb" "resources" -}}
    {{- $urlNumbers := (len  (index .Values "rbac" "eric-data-visualizer-kb" "resources")) -}}
    {{- if (gt $urlNumbers 0) -}}
      {{- range $index, $item := index .Values "rbac" "eric-data-visualizer-kb" "resources" -}}
        {{- print  $item | quote -}}{{- if (lt $index  (sub  $urlNumbers 1)) -}},{{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Define urls for protected metrics resource
*/}}
{{- define "eric-esoa-topology-handling.metrics.rbac-resources" -}}
  {{- if index .Values "rbac" "eric-pm-server" "resources" -}}
    {{- $urlNumbers := (len (index .Values "rbac" "eric-pm-server" "resources")) -}}
    {{- if (gt $urlNumbers 0) -}}
      {{- range $index, $item := index .Values "rbac" "eric-pm-server" "resources" -}}
        {{- print  $item | quote -}}{{- if (lt $index  (sub  $urlNumbers 1)) -}},{{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Define urls for protected Backup and Restore resource
*/}}
{{- define "eric-esoa-topology-handling.bur.rbac-resources" -}}
  {{- if index .Values "rbac" "eric-ctrl-bro" "resources" -}}
    {{- $urlNumbers := (len (index .Values "rbac" "eric-ctrl-bro" "resources")) -}}
    {{- if (gt $urlNumbers 0) -}}
      {{- range $index, $item := index .Values "rbac" "eric-ctrl-bro" "resources" -}}
        {{- print  $item | quote -}}{{- if (lt $index  (sub  $urlNumbers 1)) -}},{{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Enable Node Selector functionality
*/}}
{{- define "eric-esoa-topology-handling.nodeSelector" -}}
{{- if .Values.nodeSelector }}
nodeSelector:
  {{ toYaml .Values.nodeSelector | trim }}
{{- else if .Values.global.nodeSelector }}
nodeSelector:
  {{ toYaml .Values.global.nodeSelector | trim }}
{{- end }}
{{- end -}}

{{/*
Create version
*/}}
{{- define "eric-esoa-topology-handling.version" -}}
{{- printf "%s" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create Service Mesh enabling option
*/}}
{{- define "eric-esoa-topology-handling.service-mesh.enabled" }}
  {{- $globalMeshEnabled := "false" -}}
  {{- if .Values.global -}}
    {{- if .Values.global.serviceMesh -}}
        {{- $globalMeshEnabled = .Values.global.serviceMesh.enabled -}}
    {{- end -}}
  {{- end -}}
  {{- $globalMeshEnabled -}}
{{- end -}}

{{/*
Create Service Mesh Ingress enabling option
*/}}
{{- define "eric-esoa-topology-handling.service-mesh-ingress.enabled" -}}
{{ if .Values.global.serviceMesh }}
  {{ if .Values.global.serviceMesh.ingress }}
    {{ if .Values.global.serviceMesh.ingress.enabled }}
  {{- print "true" -}}
    {{ else }}
  {{- print "false" -}}
    {{- end -}}
  {{ else }}
  {{- print "false" -}}
  {{- end -}}
{{ else }}
  {{- print "false" -}}
{{ end }}
{{- end}}

{{/*
check global.security.tls.enabled since it is removed from values.yaml
*/}}
{{- define "eric-esoa-topology-handling.global-security-tls-enabled" -}}
{{- if  .Values.global -}}
  {{- if  .Values.global.security -}}
    {{- if  .Values.global.security.tls -}}
       {{- .Values.global.security.tls.enabled | toString -}}
    {{- else -}}
       {{- "false" -}}
    {{- end -}}
  {{- else -}}
       {{- "false" -}}
  {{- end -}}
{{- else -}}
{{- "false" -}}
{{- end -}}

{{- end -}}

{{/*
Create the FQDN url to be used by the topology services
*/}}
{{- define "eric-esoa-topology-handling.fqdn" -}}
{{- $fqdnPrefix := .Values.ingress.fqdnPrefix -}}
{{- $chartName := .Chart.Name -}}
{{- if index .Values.global.hosts $chartName  -}}
  {{- $fqdn := index .Values.global.hosts $chartName -}}
  {{- printf "%s" $fqdn }}
{{- else -}}
  {{- $baseHostname := .Values.global.ingress.baseHostname | required "global.ingress.baseHostname is mandatory" -}}
  {{- printf "%s.%s" $fqdnPrefix $baseHostname }}
{{- end -}}
{{- end -}}

{{/*
Create the ingressClass to be used by the topology services
*/}}
{{- define "eric-esoa-topology-handling.ingressClass" -}}
{{- if .Values.ingress.ingressClass -}}
  {{- printf "%s" .Values.ingress.ingressClass }}
{{- else -}}
  {{- $ingressClass := .Values.global.ingress.ingressClass | required "global.ingress.ingressClass is mandatory" -}}
  {{- printf "%s" $ingressClass }}
{{- end -}}
{{- end -}}

{{/*
adding TopologySpreadConstraints
*/}}
{{- define "eric-esoa-topology-handling.topologySpreadConstraints" }}
{{- range $values := .Values.topologySpreadConstraints }}
- topologyKey: {{ $values.topologyKey }}
  maxSkew: {{ $values.maxSkew | default 1 }}
  whenUnsatisfiable: {{ $values.whenUnsatisfiable | default "ScheduleAnyway" }}
{{- if $values.nodeAffinityPolicy }}
  nodeAffinityPolicy: {{ $values.nodeAffinityPolicy }}
{{- end }}
{{- if $values.nodeTaintsPolicy }}
  nodeTaintsPolicy: {{ $values.nodeTaintsPolicy }}
{{- end }}
{{- if $values.minDomains }}
  minDomains: {{ $values.minDomains }}
{{- end }}
{{- if $values.matchLabelKeys }}
  matchLabelKeys: {{ $values.matchLabelKeys }}
{{- end }}
  labelSelector:
    matchLabels:
      app: {{ template "eric-esoa-topology-handling.name" $ }}
{{- end }}
{{- end }}

{{/*
POD Antiaffinity type (soft/hard)
*/}}

{{- define "eric-esoa-topology-handling.pod-anti-affinity-type" -}}
{{- $podantiaffinity := "soft" }}
{{- if .Values.affinity -}}
  {{- $podantiaffinity = .Values.affinity.podAntiAffinity }}
{{- end -}}
{{- if eq $podantiaffinity "hard" }}
  requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchExpressions:
      - key: app.kubernetes.io/name
        operator: In
        values:
        - {{ template "eric-esoa-topology-handling.name" . }}
    topologyKey: {{ .Values.affinity.topologyKey }}
 {{- else if eq $podantiaffinity "soft" -}}
  preferredDuringSchedulingIgnoredDuringExecution:
  - weight: 100
    podAffinityTerm:
      labelSelector:
        matchExpressions:
        - key: app.kubernetes.io/name
          operator: In
          values:
          - {{ template "eric-esoa-topology-handling.name" .}}
      topologyKey: {{ .Values.affinity.topologyKey }}
 {{- end }}
{{- end }}

{/*
DR-D1120-060-AD, DR-D1120-061-AD, DR-D1120-067-AD - create tolerations
*/}}
{{- define "eric-esoa-topology-handling.tolerations" -}}
{{- range $values := .Values.tolerations }}
- key: {{ $values.key }}
  operator: {{ $values.operator }}
  {{- if $values.value }}
  value: {{ $values.value }}
  {{- end }}
  effect: {{ $values.effect }}
  tolerationSeconds: {{ $values.tolerationSeconds }}
{{- end }}
{{- end -}}

{/*
 create resource requests and limits
*/}}
{{- define "eric-esoa-topology-handling.resourceRequestsAndLimits" -}}
requests:
{{- if (index .Values "resources" .resourceName "requests" "ephemeral-storage") }}
  ephemeral-storage: {{ (index .Values "resources" .resourceName "requests" "ephemeral-storage" | quote) }}
{{- end }}
{{- if (index .Values "resources" .resourceName "requests" "memory") }}
  memory: {{ (index .Values "resources" .resourceName "requests" "memory" | quote) }}
{{- end }}
{{- if (index .Values "resources" .resourceName "requests" "cpu") }}
  cpu: {{ (index .Values "resources" .resourceName "requests" "cpu" | quote) }}
{{- end }}
limits:
{{- if (index .Values "resources" .resourceName "limits" "ephemeral-storage") }}
  ephemeral-storage: {{ (index .Values "resources" .resourceName "limits" "ephemeral-storage" | quote) }}
{{- end }}
{{- if (index .Values "resources" .resourceName "limits" "memory") }}
  memory: {{ (index .Values "resources" .resourceName "limits" "memory" | quote) }}
{{- end }}
{{- if (index .Values "resources" .resourceName "limits" "cpu") }}
  cpu: {{ (index .Values "resources" .resourceName "limits" "cpu" | quote) }}
{{- end }}
{{- end -}}