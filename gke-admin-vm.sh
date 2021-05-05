#!/bin/bash

set -x

# TODO: templatize those
CLUSTER_NAME=cluster_name
GCP_REGION=us-central1


main(){
    echo "Welcome on the admin instance for your gke demo cluster"
    install_deps

    download_falcon_sensor
    push_falcon_sensor_to_gcr
    configure_gke_access

}

configure_gke_acccess(){
    gcloud container clusters get-credentials "$CLUSTER_NAME" cluster_name --region "$GCP_REGION"
    kubect get pods
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

