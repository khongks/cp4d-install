#!/bin/bash

name=ibm-cpd-scheduling-operator
namespace=cpd-operators
version=v1.2

echo "Create ${name}"

cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-cpd-scheduling-catalog-subscription
  namespace: ${namespace}
spec:
  channel: ${version}
  installPlanApproval: Automatic
  name: ${name}
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

# confirm that the subscription was triggered
oc get sub -n ${namespace} ibm-cpd-scheduling-catalog-subscription -o jsonpath='{.status.installedCSV} {"\n"}'
# Verify that the command returns ibm-cpd-scheduling-operator.v1.1.6.

# confirm that the cluster service version (CSV) is ready
oc get csv -n ${namespace} ${name}.v1.2.3 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'
# Verify that the command returns Succeeded : install strategy completed with no errors.

# confirm that the operator is ready
oc get deployments -n ${namespace} -l olm.owner="${name}.v1.2.3" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"
# Verify that the command returns an integer greater than or equal to 1. If the command returns 0, wait for the deployment to become available.