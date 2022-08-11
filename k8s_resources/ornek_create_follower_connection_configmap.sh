#!/bin/bash

APPLICATION_NAMESPACE="conjur-uygulama-test"
CONJUR_ACCOUNT=swo
CONJUR_APPLIANCE_URL="https://conjur-follower.conjur-ns.svc.cluster.local"
CONJUR_AUTHN_URL="${CONJUR_APPLIANCE_URL}/authn-k8s/ocptest"
CONJUR_AUTHN_LOGIN=host/test-app
CONJUR_SSL_CERTIFICATE=./conjur.pem
SECRET_1_PATH="secrets/username"
SECRET_2_PATH="secrets/password"

function createCm(){
oc create configmap conjur-cm -n $APPLICATION_NAMESPACE \
  -o yaml \
  --dry-run \
  --from-literal CONJUR_ACCOUNT=${CONJUR_ACCOUNT} \
  --from-literal CONJUR_APPLIANCE_URL=${CONJUR_APPLIANCE_URL} \
  --from-literal CONJUR_AUTHN_URL=${CONJUR_AUTHN_URL} \
  --from-literal CONJUR_AUTHN_LOGIN=${CONJUR_AUTHN_LOGIN} \
  --from-literal CONJUR_AUTHN_TOKEN_FILE=/run/conjur/access-token \
  --from-file "CONJUR_SSL_CERTIFICATE=${CONJUR_SSL_CERTIFICATE}" \
  --from-literal CONJUR_USERNAME_PATH=${SECRET_1_PATH} \
  --from-literal CONJUR_PASSWORD_PATH=${SECRET_2_PATH}
}

createCm 
echo ""
echo ""
read -p "Configmap yukaridaki hali ile apply edilsin mi? (y/n): " apply
echo ""
echo ""

if [[ $apply == "y" ]]; then
  createCm | oc apply -f -
else
  exit 0
fi
