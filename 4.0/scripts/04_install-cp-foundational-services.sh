#!/bin/bash

name=ibm-common-service-operator
namespace=ibm-common-services

echo "Install Cloud Pak foundational services"

cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-common-service-operator
  namespace: ${namespace}
spec:
  channel: v3
  installPlanApproval: Automatic
  name: ${name}
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

# Verify the status of ibm-common-service-operator
oc -n ${namespace} get csv

# Verify that the custom resource definitions were created
oc get crd | grep operandrequest

# Confirm that IBM Cloud Pak foundational services API resources are available
oc api-resources --api-group operator.ibm.com