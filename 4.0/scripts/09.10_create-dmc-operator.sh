#!/bin/bash

name=ibm-cpd-dmc-operator
namespace=cpd-operators
version=v1.0

echo "Create ${name}"

cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-dmc-operator-subscription 
  namespace: ${namespace}
spec:
  channel: ${version}
  installPlanApproval: Automatic
  name: ${name}
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

oc get sub -n ${namespace} ibm-dmc-operator-subscription -o jsonpath='{.status.installedCSV} {"\n"}'

oc get csv -n ${namespace} ${name}.v1.0.2 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'

oc get deployments -n ${namespace} -l olm.owner="${name}.v1.0.2" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"