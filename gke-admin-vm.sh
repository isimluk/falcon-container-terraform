#!/bin/bash

set -x

echo "HI $USER $(whoami)" >> /etc/motd
main(){
    install_deps >> /etc/motd 2>&1
}

install_deps(){
    snap install tmux --classic
    chown -f -R "$USER" ~/.kube
    sudo addgroup --system docker
    sudo adduser "$USER" docker
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

main "$@"

