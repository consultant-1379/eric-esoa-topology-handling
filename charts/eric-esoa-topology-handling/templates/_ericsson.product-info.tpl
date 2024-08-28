{{- define "eric-esoa-topology-handling.product-info" }}
ericsson.com/product-name: "Topology Handling Application"
ericsson.com/product-number: "CXC 900 001"
ericsson.com/product-revision: {{ regexReplaceAll "(.*)[+].*" .Chart.Version "${1}" }}
{{- end }}
