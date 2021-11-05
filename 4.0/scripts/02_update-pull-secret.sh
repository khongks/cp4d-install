#!/bin/bash

echo "Update pull secret"

entitlementKey=$1

cat .dockerconfigjson | jq -r .auths

oc extract secret/pull-secret -n openshift-config --keys=.dockerconfigjson --to=. --confirm
cat .dockerconfigjson | jq . >  .dockerconfigjson.orig
mv .dockerconfigjson.orig .dockerconfigjson

entitlementKey_b64=$(echo $entitlementKey | base64)
echo $entitlementKey_b64

jq '.auths."cp.icr.io"={"auth":"{{entitlementKey_b64}}"}' .dockerconfigjson > .dockerconfigjson.new
sed -i '' "s/{{entitlementKey_b64}}/${entitlementKey_b64}/" .dockerconfigjson.new

cat .dockerconfigjson.new
mv .dockerconfigjson.new .dockerconfigjson

oc set data secret/pull-secret -n openshift-config --from-file=.dockerconfigjson