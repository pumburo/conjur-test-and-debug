#!/bin/bash

# Ornek yaml dosyasi bu dosya ile ayni path icinde mavcuttur.

APPLICATION_NAMESPACE=<uygulama_namespacei> # secret cekecek uygulamanin calisacagi namespace
CONJUR_ACCOUNT=<account_name> # conjur whoami komutu ciktisi ile alinabilir.
CONJUR_APPLIANCE_URL="https://<follower_domain_name>" # follower adresi. ornek: conjur-follower.conjur-ns.svc.cluster.local 
CONJUR_AUTHN_URL="${CONJUR_APPLIANCE_URL}/<authenticator_ismi>" # "conjur list" komutu ile alinabilir. ornek: authn-k8s/ocptest 
CONJUR_AUTHN_LOGIN=<secret_userinde_yetkili_host> # "conjur list" komutu ile alinabilir. ornek: host/test-app
CONJUR_SSL_CERTIFICATE=./conjur.pem # k8s uzerinde calisan bir poddan openssl ile alinabilir.
                                    # pod terminaline erisim ornegi: oc rsh test-app-secrets-provider-k8s-6d49699b85-vv6qq
                                    # podun terminaline eristikten sonra asagidaki komut ile sertifika alinabilir
                                    # openssl s_client -showcerts -connect conjur-follower.conjur-ns.svc.cluster.local:443
                                    # komutun ciktisindaki sertifikalarin tamami kopyalanip conjur.pem dosyasi içine yazilmali.
SECRET_1_PATH=<cekilecek_secret_path> # secret path'i
SECRET_2_PATH=<cekilecek_secret_path> # secret path'i

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