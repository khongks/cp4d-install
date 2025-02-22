#!/bin/bash

echo "Create catalog sources"

cat <<EOF |oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-operator-catalog
  namespace: openshift-marketplace
spec:
  displayName: "IBM Operator Catalog" 
  publisher: IBM
  sourceType: grpc
  image: icr.io/cpopen/ibm-operator-catalog:latest
  updateStrategy:
    registryPoll:
      interval: 45m
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-cpd-ccs-operator-catalog
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: icr.io/cpopen/ibm-cpd-ccs-operator-catalog@sha256:34854b0b5684d670cf1624d01e659e9900f4206987242b453ee917b32b79f5b7
  imagePullPolicy: Always
  displayName: CPD Common Core Services
  publisher: IBM
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-cpd-datarefinery-operator-catalog
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: icr.io/cpopen/ibm-cpd-datarefinery-operator-catalog@sha256:27c6b458244a7c8d12da72a18811d797a1bef19dadf84b38cedf6461fe53643a
  imagePullPolicy: Always
  displayName: Cloud Pak for Data IBM DataRefinery
  publisher: IBM
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-db2aaservice-cp4d-operator-catalog
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: icr.io/cpopen/ibm-db2aaservice-cp4d-operator-catalog@sha256:a0d9b6c314193795ec1918e4227ede916743381285b719b3d8cfb05c35fec071
  imagePullPolicy: Always
  displayName: IBM Db2aaservice CP4D Catalog
  publisher: IBM
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-cpd-iis-operator-catalog
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: icr.io/cpopen/ibm-cpd-iis-operator-catalog@sha256:3ad952987b2f4d921459b0d3bad8e30a7ddae9e0c5beb407b98cf3c09713efcc
  imagePullPolicy: Always
  displayName: CPD IBM Information Server
  publisher: IBM
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-cpd-wml-operator-catalog
  namespace: openshift-marketplace
spec:
  displayName: Cloud Pak for Data Watson Machine Learning
  publisher: IBM
  sourceType: grpc
  imagePullPolicy: Always
  image: icr.io/cpopen/ibm-cpd-wml-operator-catalog@sha256:d2da8a2573c0241b5c53af4d875dbfbf988484768caec2e4e6231417828cb192
  updateStrategy:
    registryPoll:
      interval: 45m
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-cpd-ws-operator-catalog
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: icr.io/cpopen/ibm-cpd-ws-operator-catalog@sha256:bf6b42df3d8cee32740d3273154986b28dedbf03349116fba39974dc29610521
  imagePullPolicy: Always
  displayName: CPD IBM Watson Studio
  publisher: IBM
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: opencontent-elasticsearch-dev-catalog
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: icr.io/cpopen/opencontent-elasticsearch-operator-catalog@sha256:bc284b8c2754af2eba81bb1edf6daa59dc823bf7a81fe91710c603f563a9a724
  displayName: IBM Opencontent Elasticsearch Catalog
  publisher: CloudpakOpen
  updateStrategy:
    registryPoll:
      interval: 45m
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-rabbitmq-operator-catalog
  namespace: openshift-marketplace
spec:
  displayName: IBM RabbitMQ operator Catalog
  publisher: IBM
  sourceType: grpc
  image: icr.io/cpopen/opencontent-rabbitmq-operator-catalog@sha256:c3b14816eabc04bcdd5c653eaf6e0824adb020ca45d81d57059f50c80f22964f
  updateStrategy:
    registryPoll:
      interval: 45m
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-cloud-databases-redis-operator-catalog
  namespace: openshift-marketplace
spec:
  displayName: ibm-cloud-databases-redis-operator-catalog
  publisher: IBM
  sourceType: grpc
  image: icr.io/cpopen/ibm-cloud-databases-redis-catalog@sha256:980e4182ec20a01a93f3c18310e0aa5346dc299c551bd8aca070ddf2a5bf9ca5
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-cpd-ws-runtimes-operator-catalog
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: icr.io/cpopen/ibm-cpd-ws-runtimes-operator-catalog@sha256:c1faf293456261f418e01795eecd4fe8b48cc1e8b37631fb6433fad261b74ea4
  imagePullPolicy: Always
  displayName: CPD Watson Studio Runtimes
  publisher: IBM
EOF


oc get catalogsource -n openshift-marketplace

# oc get catalogsource -n openshift-marketplace cpd-platform -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'
#oc get catalogsource -n openshift-marketplace ibm-cpd-scheduling-catalog -o jsonpath='{.status.connectionState.lastObservedState} {"\n"}'