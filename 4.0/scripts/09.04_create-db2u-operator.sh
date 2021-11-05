#!/bin/bash

name=ibm-cpd-db2u-operator
namespace=cpd-operators
version=v1.1

echo "Create ${name}"

cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-db2u-operator
  namespace: ${namespace}
spec:
  channel: ${version}
  name: ${name}
  installPlanApproval: Automatic
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

oc get sub -n ${namespace} ${name} -o jsonpath='{.status.installedCSV} {"\n"}'

oc get csv -n ${namespace} ${name}.v1.1.6 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'

oc get deployments -n ${namespace} -l olm.owner="${name}.v1.1.6" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"