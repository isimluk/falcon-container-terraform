#!/bin/bash

export HOME=/root

main(){
    set -x
    install_deps

    download_falcon_sensor
    push_falcon_sensor_to_gcr
    configure_gke_access

    deploy_vulnerable_app
    set +x
}

deploy_vulnerable_app(){
    kubectl apply -f https://raw.githubusercontent.com/isimluk/vulnapp/master/vulnerable.example.yaml
}

configure_gke_access(){
    gcloud container clusters get-credentials "${CLUSTER_NAME}" --zone "${GCP_ZONE}"
}

tools_image=quay.io/crowdstrike/cloud-tools-image

push_falcon_sensor_to_gcr(){
    echo "TODO push_falcon_sensor_to_gcr"
}

download_falcon_sensor(){
    export FALCON_CLIENT_ID=$(gcloud secrets versions access latest --secret="FALCON_CLIENT_ID")
    export FALCON_CLIENT_SECRET=$(gcloud secrets versions access latest --secret="FALCON_CLIENT_SECRET")
    echo "TODO download_falcon_sensor"
}

install_deps(){
    snap install docker
    snap install kubectl --classic
    docker pull -q "$tools_image"
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

main "$@" >> $LIVE_LOG 2>&1

echo "Demo initialisation completed" >> $LIVE_LOG
echo "To get pods run: sudo kubectl get pods" >> $LIVE_LOG
mv $LIVE_LOG $MOTD

for pid in $(ps aux | grep tail.-f./etc/motd | awk '{print $2}'); do
    kill "$pid"
done

