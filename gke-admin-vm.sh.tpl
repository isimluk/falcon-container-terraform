#!/bin/bash

export HOME=/root

main(){
    set -x
    install_deps

    fetch_falcon_secrets_from_gcp
    download_falcon_sensor
    push_falcon_sensor_to_gcr
    configure_gke_access

    deploy_falcon_container_sensor
    deploy_vulnerable_app
    set +x
}

deploy_falcon_container_sensor(){
    mkdir -p /yaml
    injector_file="/yaml/injector.yaml"
    docker run --rm --entrypoint installer "$FALCON_IMAGE_URI" -cid "$CID" -image "$FALCON_IMAGE_URI" > "$injector_file"
    kubectl apply -f "$injector_file"

    kubectl wait --for=condition=ready pod -n falcon-system -l app=injector
}

deploy_vulnerable_app(){
    wget -q -O /yaml/vulnerable.example.yaml https://raw.githubusercontent.com/isimluk/vulnapp/master/vulnerable.example.yaml
    kubectl apply -f /yaml/vulnerable.example.yaml
    kubectl wait --for=condition=ready service vulnerable-example-com
}

export CLOUDSDK_CORE_DISABLE_PROMPTS=1

configure_gke_access(){
    gcloud container clusters get-credentials "${CLUSTER_NAME}" --zone "${GCP_ZONE}"
}

push_falcon_sensor_to_gcr(){
    FALCON_IMAGE_URI="gcr.io/${GCP_PROJECT}/falcon-sensor:latest"
    docker tag "falcon-sensor:$local_tag" "$FALCON_IMAGE_URI"
    gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://gcr.io
    docker push "$FALCON_IMAGE_URI"
}

download_falcon_sensor(){
    gofalcon_version=0.2.2
    pkg=gofalcon-$gofalcon_version-1.x86_64.deb
    wget -q -O $pkg https://github.com/CrowdStrike/gofalcon/releases/download/v$gofalcon_version/$pkg
    sudo apt install ./$pkg > /dev/null


    tmpdir=$(mktemp -d)
    pushd "$tmpdir" > /dev/null
      falcon_sensor_download --os-name=Container
      local_tag=$(cat ./falcon-sensor-* | docker load -q | grep 'Loaded image: falcon-sensor:' | sed 's/^.*Loaded image: falcon-sensor://g')
    popd > /dev/null
    rm -rf "$tmpdir"
}

fetch_falcon_secrets_from_gcp(){
    set +x
    FALCON_CLIENT_ID=$(gcloud secrets versions access latest --secret="FALCON_CLIENT_ID")
    FALCON_CLIENT_SECRET=$(gcloud secrets versions access latest --secret="FALCON_CLIENT_SECRET")
    FALCON_CLOUD=$(gcloud secrets versions access latest --secret="FALCON_CLOUD")
    CID=$(gcloud secrets versions access latest --secret="FALCON_CID")
    export FALCON_CLIENT_ID
    export FALCON_CLIENT_SECRET
    export FALCON_CLOUD
    export CID
    set -x
}

install_deps(){
    snap install docker
    snap install kubectl --classic
}

progname=$(basename "$0")

die(){
    echo "$progname: fatal error: $*"
    exit 1
}

err_handler() {
    echo "Error on line $1"
}

trap 'err_handler $LINENO' ERR


MOTD=/etc/motd
LIVE_LOG=$MOTD.log

echo "Welcome to the admin instance for your gke demo cluster. Installation log follows" > $LIVE_LOG
echo 'ps aux | grep -v grep | grep -q google_metadata_script_runner.startup && tail -f '$LIVE_LOG >> /etc/bash.bashrc

set -e -o pipefail
main "$@" >> $LIVE_LOG 2>&1

echo "Demo initialisation completed" >> $LIVE_LOG
echo "To get pods run: sudo kubectl get pods" >> $LIVE_LOG
echo "vulnerable.example.com is available at http://$(kubectl get service vulnerable-example-com  -o yaml -o=jsonpath="{.status.loadBalancer.ingress[0].ip}")/" >> $LIVE_LOG
mv $LIVE_LOG $MOTD

for pid in $(ps aux | grep tail.-f./etc/motd | awk '{print $2}'); do
    kill "$pid"
done

