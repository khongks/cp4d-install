#!/bin/bash

cat << EOF | oc apply -f -
apiVersion: machineconfiguration.openshift.io/v1
kind: KubeletConfig
metadata:
  name: db2u-kubelet
spec:
  machineConfigPoolSelector:
    matchLabels:
      db2u-kubelet: sysctl
  kubeletConfig:
    allowedUnsafeSysctls:
      - "kernel.msg*"
      - "kernel.shm*"
      - "kernel.sem"
EOF

oc label machineconfigpool worker db2u-kubelet=sysctl

oc get machineconfigpool

cat << EOF | oc apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: kernel-optimization
  namespace: kube-system
  labels:
    tier: management
    app: kernel-optimization
spec:
  selector:
    matchLabels:
      name: kernel-optimization
  template:
    metadata:
      labels:
        name: kernel-optimization
    spec:
      hostNetwork: true
      hostPID: true
      hostIPC: true
      initContainers:
        - command:
            - sh
            - -c
            - sysctl -w net.ipv4.ip_local_port_range="1025 65535"; sysctl -w net.core.somaxconn=32768;
          image: alpine:3.6
          imagePullPolicy: IfNotPresent
          name: sysctl
          resources: {}
          securityContext:
            privileged: true
            capabilities:
              add:
                - NET_ADMIN
          volumeMounts:
            - name: modifysys
              mountPath: /sys
      containers:
        - resources:
            requests:
              cpu: 0.01
          image: alpine:3.6
          name: sleepforever
          command: ["/bin/sh", "-c"]
          args:
            - >
              while true; do
                sleep 100000;
              done
      volumes:
        - name: modifysys
          hostPath:
            path: /sys
EOF