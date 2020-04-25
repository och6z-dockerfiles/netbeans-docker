#!/bin/bash
set -e

if [[ $(echo "${PRODUCT_VERSION}" | cut --bytes=4) = "0" ]]; then
    wget --continue --directory-prefix=/home/ ${PRODUCT_DOWNLOAD_URL}/incubator/netbeans/incubating-netbeans/incubating-${PRODUCT_VERSION}/incubating-netbeans-${PRODUCT_VERSION}-bin.zip
    unzip /home/incubating-netbeans-${PRODUCT_VERSION}-bin.zip -d /home/
    rm --force /home/incubating-netbeans-${PRODUCT_VERSION}-bin.zip
elif [[ $(echo "${PRODUCT_VERSION}" | cut --bytes=4) = "3" ]]; then
    wget --continue --directory-prefix=/home/ ${PRODUCT_DOWNLOAD_URL}/netbeans/netbeans/${PRODUCT_VERSION}/netbeans-${PRODUCT_VERSION}-bin.zip
    unzip /home/netbeans-${PRODUCT_VERSION}-bin.zip -d /home/
    rm --force /home/netbeans-${PRODUCT_VERSION}-bin.zip
fi

exec "$@"
