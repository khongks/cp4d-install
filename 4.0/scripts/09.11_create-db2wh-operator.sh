#!/bin/bash

name=ibm-db2wh-cp4d-operator
namespace=cpd-operators
version=v1.0

echo "Create ${name}"

cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-db2wh-cp4d-operator-catalog-subscription
  namespace: ${namespace}
spec:
  channel: ${version}
  name: ${name}
  installPlanApproval: Automatic
  source: ibm-operator-catalog
  sourceNamespace: openshift-marketplace
EOF

oc get sub -n ${namespace} ibm-db2wh-cp4d-operator-catalog-subscription -o jsonpath='{.status.installedCSV} {"\n"}'

oc get csv -n ${namespace} ${name}.v1.0.3 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'

oc get deployments -n operator-project -l olm.owner="${name}.v1.0.3" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"