#!/bin/bash

set -x


main(){
    echo "Welcome on the admin instance for your gke demo cluster"
    install_deps

    download_falcon_sensor
    push_falcon_sensor_to_gcr
    configure_gke_access

}

configure_gke_acccess(){
    gcloud container clusters get-credentials
    kubect get pods
}

tools_image=quay.io/crowdstrike/cloud-tools-image

push_falcon_sensor_to_gcr(){
    echo "TODO push_falcon_sensor_to_gcr"
}

download_falcon_sensor(){
    docker pull -q $tools_image
    echo "TODO download_falcon_sensor"
}

install_deps(){
    snap install docker --classic
    gcloud components install kubectl
    docker pull "$tools_image"
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

