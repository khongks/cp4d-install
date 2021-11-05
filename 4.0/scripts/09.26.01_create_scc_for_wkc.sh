#!/bin/bash

prefix=wkc-iis
scc_name=${prefix}-scc
sa_name=${prefix}-sa
rolebinding_name=${scc_name}-rb
namespace=cpd-instance

# Create custom security context constraint (SCC)
cat <<EOF |oc create -f -
allowHostDirVolumePlugin: false
allowHostIPC: false
allowHostNetwork: false
allowHostPID: false
allowHostPorts: false
allowPrivilegeEscalation: true
allowPrivilegedContainer: false
allowedCapabilities: null
apiVersion: security.openshift.io/v1
defaultAddCapabilities: null
fsGroup:
  type: RunAsAny
kind: SecurityContextConstraints
metadata:
  annotations:
    kubernetes.io/description: WKC/IIS provides all features of the restricted SCC
      but runs as user 10032.
  name: ${scc_name}
readOnlyRootFilesystem: false
requiredDropCapabilities:
- KILL
- MKNOD
- SETUID
- SETGID
runAsUser:
  type: MustRunAs
  uid: 10032
seLinuxContext:
  type: MustRunAs
supplementalGroups:
  type: RunAsAny
volumes:
- configMap
- downwardAPI
- emptyDir
- persistentVolumeClaim
- projected
- secret
users:
- system:serviceaccount:${namespace}:${sa_name}
EOF

# Verify that the SCC was created
oc get scc wkc-iis-scc

# Create the SCC cluster role for wkc-iis-scc:
oc create clusterrole system:openshift:scc:${scc_name} --verb=use --resource=scc --resource-name=${scc_name}

# Assign the wkc-iis-sa service account to the SCC cluster role
oc create rolebinding ${rolebinding_name} --clusterrole=system:openshift:scc:${scc_name} --serviceaccount=${namespace}:${sa_name}

# Confirm that the wkc-iis-sa service account can use the wkc-iis-scc SCC:
oc adm policy who-can use scc ${scc_name} -n ${namespace} | grep "${sa_name}"