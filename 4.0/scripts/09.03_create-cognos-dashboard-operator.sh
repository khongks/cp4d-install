#!/bin/bash

name=ibm-cpd-cde-operator
namespace=cpd-operators
version=v1.0

echo "Create ${name}"

cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  labels:
    app.kubernetes.io/instance: ibm-cde-operator-subscription
    app.kubernetes.io/managed-by: ibm-cde-operator
    app.kubernetes.io/name: ibm-cde-operator-subscription
  name: ibm-cde-operator-subscription
  namespace: ${namespace}
spec:
  channel: ${version}
  installPlanApproval: Automatic
  name: ${name}
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

# confirm that the subscription was triggered
oc get sub -n ${namespace} ibm-cde-operator-subscription -o jsonpath='{.status.installedCSV} {"\n"}'
# Verify that the command returns ibm-cpd-cde-operator.v1.0.2

# confirm that the cluster service version (CSV) is ready
oc get csv -n ${namespace} ${name}.v1.0.2 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'
# Verify that the command returns Succeeded : install strategy completed with no errors.

# confirm that the operator is ready
oc get deployments -n ${namespace} -l olm.owner="${name}.v1.0.2" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"
# Verify that the command returns an integer greater than or equal to 1. If the command returns 0, wait for the deployment to become available.