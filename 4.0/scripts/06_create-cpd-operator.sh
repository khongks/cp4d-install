#!/bin/bash

name=cpd-platform-operator
namespace=cpd-operators
version=v2.0

echo "Create ${name}"

cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: cpd-operator
  namespace: ${namespace}
spec:
  channel: ${version}
  installPlanApproval: Automatic
  name: ${name}
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

## If you are running a specialized installation (installing the IBM Cloud Pak® for Data platform operator and 
## the IBM Cloud Pak foundational services in separate projects), create an operator subscription for the 
## IBM NamespaceScope Operator in the IBM Cloud Pak for Data platform operator project
cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-namespace-scope-operator
  namespace: ${namespace}
spec:
  channel: ${version}
  installPlanApproval: Automatic
  name: ${name}
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

# confirm that the subscription was triggered
oc get sub -n ${namespace} cpd-operator -o jsonpath='{.status.installedCSV} {"\n"}'
# Verify that the command returns cpd-platform-operator.v2.0.4.

# confirm that the cluster service version (CSV) is ready.
oc get csv -n ${namespace} ${name}.v2.0.4 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'
# Verify that the command returns Succeeded : install strategy completed with no errors.

# confirm that the operator is ready
oc get deployments -n ${namespace} -l olm.owner="${name}.v2.0.4" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"
# Verify that the command returns an integer greater than or equal to 1. If the command returns 0, wait for the deployment to become available.