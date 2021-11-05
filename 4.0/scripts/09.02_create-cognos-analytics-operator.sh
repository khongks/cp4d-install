#!/bin/bash

name=ibm-cpd-ca-operator
namespace=cpd-operators
version=v4.0

echo "Create ${name}"

cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-ca-operator-catalog-subscription
  labels:
    app.kubernetes.io/instance: ${name}
    app.kubernetes.io/managed-by: ${name}
    app.kubernetes.io/name: ${name}
  namespace: ${namespace}
spec:
  channel: ${version}
  name: ${name}
  installPlanApproval: Automatic
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

# confirm that the subscription was triggered
oc get sub -n ${namespace} ibm-ca-operator-catalog-subscription -o jsonpath='{.status.installedCSV} {"\n"}'
# Verify that the command returns ibm-cpd-ca-operator.v4.0.2.

# confirm that the cluster service version (CSV) is ready
oc get csv -n ${namespace} ${name}.v4.0.2 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'

# confirm that the operator is ready
oc get deployments -n ${namespace} -l olm.owner="${name}.v4.0.2" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"
# Verify that the command returns an integer greater than or equal to 1. If the command returns 0, wait for the deployment to become available.
