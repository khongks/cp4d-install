#!/bin/bash

name=Ibmcpd-cr
namespace=cpd-instance
license=Enterprise #Enterprise|Standard
file_rwx_storageclass=ibmc-file-gold-gid
block_rwo_storageclass=ibmc-block-gold

cat <<EOF |oc apply -f -
apiVersion: cpd.ibm.com/v1
kind: Ibmcpd
metadata:
  name: ${name}
  namespace: ${namespace}
spec:
  license:
    accept: true
    license: ${license}
  storageClass: ${file_rwx_storageclass}
  zenCoreMetadbStorageClass: ${block_rwo_storageclass}
EOF