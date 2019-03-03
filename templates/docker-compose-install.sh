#!/bin/bash
# Installs a recent version of docker-compose
# as on recent Ubuntu version it's pretty old
# but also this script could help to keep consistency
# between developer and production environment

function install_armv7() {
    sudo apt-get update
    sudo apt-get install -y apt-transport-https
    echo "deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ jessie main" | sudo tee /etc/apt/sources.list.d/hypriot.list
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 37BBEE3F7AD95B3F

    sudo apt-get update
    sudo apt-get install -y docker-compose docker-hypriot

    return $?
}

function install_other_arch() {
    COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9]+\.[0-9]+$" | sort -V | tail -n 1`
    sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"

    if [[ $(cat /usr/local/bin/docker-compose) == *"Not found"* ]]; then
        echo " docker-compose version not found for specified kernel and architecture"
        exit 1
    fi

    sudo chmod +x /usr/local/bin/docker-compose
    return $?
}

if [[ $(uname -m) == "armv7l" ]] || [[ $(uname -m) == "aarch64" ]]; then
    install_armv7
    exit $?
fi

install_other_arch
exit $?
