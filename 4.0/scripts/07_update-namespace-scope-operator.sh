#!/bin/bash

namespace=cpd-operators
instance_namespace=cpd-instance

cat <<EOF |oc apply -f -
apiVersion: operator.ibm.com/v1
kind: NamespaceScope
metadata:
  name: cpd-operators
  namespace: ${namespace}
spec:
  csvInjector:
    enable: true
  namespaceMembers:
  - ${namespace}
  - ${instance_namespace}
EOF