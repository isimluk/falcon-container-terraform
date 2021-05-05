#!/bin/bash

# TODO: templatize those
CLUSTER_NAME=cluster_name
GCP_ZONE=us-central1-c

export HOME=/root

echo 'ps aux | grep -v grep | grep -q google_metadata_script_runner.startup && tail -f /etc/motd' >> /etc/bash.bashrc

set -x

main(){
    echo "Welcome on the admin instance for your gke demo cluster"

    install_deps

    download_falcon_sensor
    push_falcon_sensor_to_gcr
    configure_gke_access

    deploy_vulnerable_app

    set +x
    echo "Demo initialisation completed"
    for pid in $(ps aux | grep tail.-f./etc/motd | awk '{print $2}'); do
        kill "$pid"
    done
}

deploy_vulnerable_app(){
    kubectl apply -f https://raw.githubusercontent.com/isimluk/vulnapp/master/vulnerable.example.yaml
}

configure_gke_access(){
    gcloud container clusters get-credentials "$CLUSTER_NAME" --zone "$GCP_ZONE"
}

tools_image=quay.io/crowdstrike/cloud-tools-image

push_falcon_sensor_to_gcr(){
    echo "TODO push_falcon_sensor_to_gcr"
}

download_falcon_sensor(){
    echo "TODO download_falcon_sensor"
}

install_deps(){
    snap install docker --classic
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

main "$@" >> /etc/motd 2>&1

