#!/bin/bash

name=ibm-cpd-wkc-operator
namespace=cpd-operators
version=v1.0

echo "Create ${name}"

cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  labels:
    app.kubernetes.io/instance:  ibm-cpd-wkc-operator-catalog-subscription
    app.kubernetes.io/managed-by: ${name}
    app.kubernetes.io/name:  ibm-cpd-wkc-operator-catalog-subscription
  name: ibm-cpd-wkc-operator-catalog-subscription
  namespace: ${namespace}
spec:
    channel: v1.0
    installPlanApproval: Automatic
    name: ${name}
    source: ibm-operator-catalog
    sourceNamespace: openshift-marketplace
EOF

oc get sub -n ${namespace} ibm-cpd-wkc-operator-catalog-subscription -o jsonpath='{.status.installedCSV} {"\n"}'

oc get csv -n ${namespace} ${name}.v1.0.2 -o jsonpath='{ .status.phase } : { .status.message} {"\n"}'

oc get deployments -n ${namespace} -l olm.owner="${name}.v1.0.2" -o jsonpath="{.items[0].status.availableReplicas} {'\n'}"